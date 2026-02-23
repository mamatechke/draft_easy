module Admin
  class AnalyticsController < ApplicationController
    before_action :require_admin

    def index
      @total_users = User.count
      @total_cases = Case.count
      @total_subscribed = User.where(subscribed: true).count
      @total_active_7_days = Ahoy::Visit.where('started_at >= ?',
                                               7.days.ago).where.not(user_id: nil).select(:user_id).distinct.count
      @recent_users = User.order(created_at: :desc).limit(10)
      @recent_cases = Case.order(created_at: :desc).limit(10)

      @daily_cases = Case.where('created_at >= ?', 30.days.ago)
                         .group('DATE(created_at)')
                         .count
                         .map { |date, count| { date: date, count: count } }

      @daily_signups = User.where('created_at >= ?', 30.days.ago)
                           .group('DATE(created_at)')
                           .count
                           .map { |date, count| { date: date, count: count } }
    end
  end
end
