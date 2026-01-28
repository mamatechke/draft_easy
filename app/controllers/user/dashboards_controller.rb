class User::DashboardsController < ApplicationController
  def show
    @recent_cases = Current.user ? Current.user.cases.order(created_at: :desc).limit(3) : []
  end
end
