# Updated extraction logic to support both original and bullet/colon inline label formats
class CasePdfAutoFiller
  # Map field names to possible label patterns
  FIELD_LABELS = {
    case_name: [
      /^Case Name\s*\n(.+)/i, # original
      /^\s*[•\-*]\s*Case Name\s*[:：]\s*(.+)$/i # bullet/colon inline
    ],
    citation: [
      /^Citation\s*\n(.+)/i,
      /^\s*[•\-*]\s*Citation\s*[:：]\s*(.+)$/i
    ],
    court: [
      /^Court\s*\n(.+)/i,
      /^\s*[•\-*]\s*Court\s*[:：]\s*(.+)$/i
    ],
    jurisdiction: [
      /^Jurisdiction\s*\n(.+)/i,
      /^\s*[•\-*]\s*Jurisdiction\s*[:：]\s*(.+)$/i
    ],
    decision_year: [
      /^Year\s*\n(\d{4})/i,
      /^\s*[•\-*]\s*Year\s*[:：]\s*(\d{4})$/i
    ],
    procedural_history: [
      /^Procedural History\s*\n([\s\S]+?)^Facts\s*\n/i,
      /^\s*[•\-*]\s*Procedural History\s*[:：]\s*([\s\S]+?)(^\s*[•\-*]\s*Facts\s*[:：]|^Facts\s*\n)/i
    ],
    facts: [
      /^Facts\s*\n([\s\S]+?)^Legal Issue\s*\n/i,
      /^\s*[•\-*]\s*Facts\s*[:：]\s*([\s\S]+?)(^\s*[•\-*]\s*Legal Issue\s*[:：]|^Legal Issue\s*\n)/i
    ],
    legal_issue: [
      /^Legal Issue\s*\n([\s\S]+?)^Holding\s*\n/i,
      /^\s*[•\-*]\s*Legal Issue\s*[:：]\s*([\s\S]+?)(^\s*[•\-*]\s*Holding\s*[:：]|^Holding\s*\n)/i
    ],
    holding: [
      /^Holding\s*\n([\s\S]+?)^Rule of Law\s*\n/i,
      /^\s*[•\-*]\s*Holding\s*[:：]\s*([\s\S]+?)(^\s*[•\-*]\s*Rule of Law\s*[:：]|^Rule of Law\s*\n)/i
    ],
    rule_of_law: [
      /^Rule of Law\s*\n([\s\S]+?)^Reasoning\s*\n/i,
      /^\s*[•\-*]\s*Rule of Law\s*[:：]\s*([\s\S]+?)(^\s*[•\-*]\s*Reasoning\s*[:：]|^Reasoning\s*\n)/i
    ],
    reasoning: [
      /^Reasoning\s*\n([\s\S]+?)^Conclusion\s*\n/i,
      /^\s*[•\-*]\s*Reasoning\s*[:：]\s*([\s\S]+?)(^\s*[•\-*]\s*Conclusion\s*[:：]|^Conclusion\s*\n)/i
    ],
    conclusion: [
      /^Conclusion\s*\n([\s\S]+?)(^Concurring Opinions\s*\n|^Dissenting Opinions\s*\n|\z)/i,
      /^\s*[•\-*]\s*Conclusion\s*[:：]\s*([\s\S]+?)(^\s*[•\-*]\s*Concurring Opinions\s*[:：]|^\s*[•\-*]\s*Dissenting Opinions\s*[:：]|\z)/i
    ],
    concurring_opinions: [
      /^Concurring Opinions\s*\n([\s\S]+?)(^Dissenting Opinions\s*\n|\z)/i,
      /^\s*[•\-*]\s*Concurring Opinions\s*[:：]\s*([\s\S]+?)(^\s*[•\-*]\s*Dissenting Opinions\s*[:：]|\z)/i
    ],
    dissenting_opinions: [
      /^Dissenting Opinions\s*\n([\s\S]+)/i,
      /^\s*[•\-*]\s*Dissenting Opinions\s*[:：]\s*([\s\S]+)/i
    ]
  }

  def self.extract_fields(text)
    result = {}
    # Normalize line endings and ensure each label is at the start of a line
    norm_text = text.gsub("\r\n", "\n").tr("\r", "\n")
    FIELD_LABELS.each do |field, regexes|
      Array(regexes).each do |regex|
        match = norm_text.match(regex)
        if match && match[1]
          result[field] = match[1].strip
          break
        end
      end
    end
    result
  end
end
