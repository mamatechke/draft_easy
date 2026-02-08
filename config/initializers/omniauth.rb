require 'omniauth-google-oauth2'

puts "OmniAuth Google loaded: #{OmniAuth::Strategies.constants.include?(:GoogleOauth2)}"

Rails.application.config.middleware.use OmniAuth::Strategies::GoogleOauth2, Rails.application.credentials.google_client_id, Rails.application.credentials.google_client_secret

puts "OmniAuth middleware inserted"
