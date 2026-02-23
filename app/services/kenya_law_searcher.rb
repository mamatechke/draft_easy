require 'httparty'
require 'nokogiri'

class KenyaLawSearcher
  BASE_URL = 'https://new.kenyalaw.org'
  SEARCH_URL = "#{BASE_URL}/search"

  CACHE_EXPIRY = 24.hours

  def self.search(query, limit: 5)
    return mock_results(query, limit) unless ENV['KENYA_LAW_ENABLED'] == 'true'

    Rails.cache.fetch("kenya_law_#{query.parameterize}", expires_in: CACHE_EXPIRY) do
      fetch_search_results(query, limit)
    end
  rescue StandardError => e
    Rails.logger.error "Kenya Law search error: #{e.message}"
    mock_results(query, limit)
  end

  def self.fetch_search_results(query, limit)
    results = []
    page = 1

    while results.length < limit
      response = HTTParty.get("#{SEARCH_URL}", {
                                query: {
                                  q: query,
                                  page: page
                                },
                                headers: {
                                  'User-Agent' => 'Mozilla/5.0 (compatible; DraftEase/1.0)',
                                  'Accept' => 'text/html'
                                },
                                timeout: 15
                              })

      doc = Nokogiri::HTML(response.body)

      cases = parse_cases(doc)
      break if cases.empty?

      results.concat(cases)
      page += 1
    end

    results.first(limit)
  end

  def self.parse_cases(doc)
    cases = []

    doc.css('.search-result, .judgment-item, article.judgment, .result-item').each do |node|
      title = node.css('h2, h3, .title, a.title').text.strip
      next if title.empty?

      summary = node.css('p, .excerpt, .summary').text.strip.truncate(200)
      link = node.css('a').first&.attr('href')
      link = "#{BASE_URL}#{link}" if link.present? && !link.start_with?('http')

      citation_match = title.match(/\[(\d{4})\]?\s*([A-Z]+\s*\d+)?/i)
      year = citation_match ? citation_match[1].to_i : nil
      citation = citation_match ? title.match(/\[[\d,]+\]\s*(KLR|KE.*)/i)&.[](0) : nil

      cases << {
        title: title,
        summary: summary,
        link: link,
        citation: citation,
        year: year,
        tags: extract_tags(node)
      }
    end

    cases
  end

  def self.extract_tags(node)
    tags = []
    node.css('.tag, .badge, .category').each do |tag|
      tags << tag.text.strip.downcase
    end
    tags
  end

  def self.mock_results(query, limit)
    mock_cases = [
      {
        title: 'Republic v. Kenya Airways Ltd [2023] KLR',
        summary: 'Judicial review on procedural fairness in administrative decisions regarding aviation licensing.',
        link: 'https://new.kenyalaw.org/judgments/supreme-court/2345',
        citation: '[2023] KLR',
        year: 2023,
        tags: ['judicial review', 'administrative law']
      },
      {
        title: 'Mwangi v. National Bank of Kenya [2022] KLR',
        summary: 'Employment law case regarding wrongful termination and breach of contract.',
        link: 'https://new.kenyalaw.org/judgments/high-court/5678',
        citation: '[2022] KLR',
        year: 2022,
        tags: ['employment', 'breach of contract']
      },
      {
        title: 'Ochieng v. Attorney General [2021] KLR',
        summary: 'Constitutional law case regarding fundamental rights and freedoms.',
        link: 'https://new.kenyalaw.org/judgments/court-of-appeal/9012',
        citation: '[2021] KLR',
        year: 2021,
        tags: ['constitutional law', 'human rights']
      },
      {
        title: 'Kenya Breweries Ltd v. Kenya Revenue Authority [2020] KLR',
        summary: 'Tax dispute regarding excise duties and corporate taxation.',
        link: 'https://new.kenyalaw.org/judgments/high-court/3456',
        citation: '[2020] KLR',
        year: 2020,
        tags: %w[tax commercial]
      },
      {
        title: 'Nairobi Metropolitan v. County Government of Nairobi [2019] KLR',
        summary: 'Devolution case regarding powers and functions of county governments.',
        link: 'https://new.kenyalaw.org/judgments/high-court/7890',
        citation: '[2019] KLR',
        year: 2019,
        tags: %w[devolution constitutional]
      },
      {
        title: 'Environmental Justice v. National Environmental Management Authority [2023] KLR',
        summary: 'Environmental law case regarding EIA compliance and pollution control.',
        link: 'https://new.kenyalaw.org/judgments/environment-and-land/4567',
        citation: '[2023] KLR',
        year: 2023,
        tags: ['environment', 'public interest']
      },
      {
        title: 'Smith v. Standard Chartered Bank [2022] KLR',
        summary: 'Banking dispute regarding loan defaults and foreclosure procedures.',
        link: 'https://new.kenyalaw.org/judgments/high-court/2345',
        citation: '[2022] KLR',
        year: 2022,
        tags: %w[banking commercial]
      },
      {
        title: 'Workers Union v. Kenya Airways [2021] KLR',
        summary: 'Labour relations case regarding collective bargaining and trade disputes.',
        link: 'https://new.kenyalaw.org/judgments/employment-labour/1234',
        citation: '[2021] KLR',
        year: 2021,
        tags: %w[labour employment]
      }
    ]

    query_down = query.downcase
    filtered = mock_cases.select do |c|
      c[:title].downcase.include?(query_down) ||
        c[:summary].downcase.include?(query_down) ||
        c[:tags].any? { |t| t.include?(query_down) }
    end

    filtered.any? ? filtered.take(limit) : mock_cases.take(limit)
  end
end
