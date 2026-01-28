# app/services/ollama_summarizer.rb
# Summarizes text using a local Ollama LLM (e.g., llama3, mistral)
# Requires Ollama running on http://localhost:11434

require "net/http"
require "json"

class OllamaSummarizer
  DEFAULT_MODEL = "llama3" # Change to 'mistral' or another if desired
  OLLAMA_URL = "http://localhost:11434/api/generate"

  def self.summarize(text, model: DEFAULT_MODEL, prompt: nil)
    prompt ||= "Summarize the following legal case in plain English, focusing on the key facts, issues, and outcome:\n\n#{text}"
    body = {
      model: model,
      prompt: prompt,
      stream: false
    }
    uri = URI(OLLAMA_URL)
    http = Net::HTTP.new(uri.host, uri.port)
    http.read_timeout = 180
    http.open_timeout = 30
    request = Net::HTTP::Post.new(uri.path, {"Content-Type" => "application/json"})
    request.body = body.to_json
    response = http.request(request)
    json = JSON.parse(response.body)
    json["response"] || json["message"] || "No summary returned."
  rescue => e
    "[Ollama error] #{e.class}: #{e.message}"
  end
end
