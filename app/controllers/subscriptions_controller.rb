class SubscriptionsController < ApplicationController
  before_action :require_login

  def index
    @user = Current.user
  end

  private

  def require_login
    redirect_to sign_in_path unless Current.user
  end
end
