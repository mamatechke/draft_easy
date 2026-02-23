require 'net/http'
require 'json'

class GroqClient
  API_URL = 'https://api.groq.com/openai/v1/chat/completions'
  DEFAULT_MODEL = 'llama-3.3-70b-versatile'

  def self.summarize(text, model: DEFAULT_MODEL)
    prompt = "You are a legal document analyzer. Summarize the following legal case in plain English, focusing on key facts, issues, and outcome:\n\n#{text}"
    chat(prompt, model: model)
  end

  def self.generate_draft(summary:, precedents:, facts:, style: 'formal')
    prompt = case style
             when 'concise'
               'Generate a concise legal draft based on the following information.'
             when 'formal'
               'Generate a formal legal judgment draft based on the following information.'
             else
               'Generate a standard legal draft based on the following information.'
             end

    full_prompt = "#{prompt}\n\nCase Summary: #{summary}\n\nRelevant Precedents: #{precedents}\n\nCase Facts: #{facts}"

    chat(full_prompt)
  end

  def self.chat(prompt, model: DEFAULT_MODEL)
    return '[Groq error] API key not configured' unless ENV['GROQ_API_KEY'].present?

    body = {
      model: model,
      messages: [{ role: 'user', content: prompt }],
      temperature: 0.3,
      max_tokens: 4096
    }

    uri = URI(API_URL)
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    http.read_timeout = 180
    http.open_timeout = 30

    request = Net::HTTP::Post.new(uri.path, {
                                    'Content-Type' => 'application/json',
                                    'Authorization' => "Bearer #{ENV['GROQ_API_KEY']}"
                                  })

    request.body = body.to_json
    response = http.request(request)

    if response.code == '200'
      json = JSON.parse(response.body)
      json.dig('choices', 0, 'message', 'content') || 'No response content.'
    else
      "[Groq error] #{response.code}: #{response.message}"
    end
  rescue StandardError => e
    "[Groq error] #{e.class}: #{e.message}"
  end
end
