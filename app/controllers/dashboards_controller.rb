class DashboardsController < ApplicationController
  before_action :require_login

  def show
    @stats = dashboard_stats
    @recent_cases = Current.user.cases.order(updated_at: :desc).limit(5)
  end

  private

  def dashboard_stats
    cases = Current.user.cases
    {
      total: cases.count,
      this_month: cases.where(created_at: Time.current.beginning_of_month..Time.current.end_of_month).count,
      jurisdictions: cases.select(:jurisdiction).distinct.count
    }
  end

  def require_login
    redirect_to sign_in_path unless Current.user
  end
end
