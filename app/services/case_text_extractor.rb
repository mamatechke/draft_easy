require "pdf/reader"
# require 'docsplit' # Uncomment if using Docsplit for DOCX

class CaseTextExtractor
  def self.extract(document)
    return "" unless document.attached?

    case document.content_type
    when "application/pdf"
      extract_pdf(document)
    # when "application/vnd.openxmlformats-officedocument.wordprocessingml.document"
    #   extract_docx(document)
    else
      ""
    end
  end

  def self.extract_pdf(document)
    text = ""
    document.open do |file|
      reader = PDF::Reader.new(file)
      reader.pages.each { |page| text << page.text }
    end
    text
  rescue
    ""
  end

  # def self.extract_docx(document)
  #   # Implement DOCX extraction if Docsplit or similar is available
  #   ""
  # end
end
