class DeadlinesController < ApplicationController
  before_action :require_login

  def index
    @cases = Current.user.cases.where.not(deadline: nil).order(deadline: :asc)
  end

  private

  def require_login
    redirect_to sign_in_path unless Current.user
  end
end
