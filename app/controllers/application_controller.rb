class ApplicationController < ActionController::Base
  before_action :set_current_request_details

  include Authentification
  include Internationalization
  include Analytics

  def set_current_request_details
    Current.user_agent = request.user_agent
    Current.ip_address = request.ip
  end

  def current_blazer_user
    Current.user if Current.user&.admin?
  end

  def require_admin
    return if Current.user&.admin?

    redirect_to root_path, alert: 'Access denied. Admin only.'
  end
end
