class PrecedentSearcher
  def self.search(query)
    # Mock Kenya Law results (replace with real API later, e.g., https://kenyalaw.org API)
    mock_precedents = [
      { title: "Republic v. Doe [2023] KLR", summary: "Precedent on procedural fairness in arbitration.", link: "https://kenyalaw.org/case1", tags: ["arbitration", "fairness"] },
      { title: "Smith v. State [2022] KLR", summary: "Evidence admissibility ruling in litigation.", link: "https://kenyalaw.org/case2", tags: ["litigation", "evidence"] },
      { title: "Johnson v. Corporation [2021] KLR", summary: "Contract interpretation in appeals.", link: "https://kenyalaw.org/case3", tags: ["appeal", "contract"] },
      { title: "Kenya Revenue Authority v. Taxpayer [2020] KLR", summary: "Tax dispute resolution.", link: "https://kenyalaw.org/case4", tags: ["tax", "dispute"] },
      { title: "Environmental Case [2019] KLR", summary: "Environmental law compliance.", link: "https://kenyalaw.org/case5", tags: ["environment", "compliance"] }
    ]

    # Basic search: filter by query in title or summary
    results = mock_precedents.select do |p|
      p[:title].downcase.include?(query.downcase) || p[:summary].downcase.include?(query.downcase)
    end

    results.take(5) # Limit to 5 results
  end
end