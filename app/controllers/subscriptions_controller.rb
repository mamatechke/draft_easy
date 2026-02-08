class SubscriptionsController < ApplicationController
  before_action :require_login

  def index
    @user = Current.user
    @plans = Plan.all
  end

  def create
    plan = Plan.find(params[:plan_id])
    # Handle Stripe subscription creation
    # For now, just update the user
    Current.user.update(plan: plan, subscribed: true)
    redirect_to subscriptions_path, notice: "Subscribed to #{plan.name} plan"
  end

  private

  def require_login
    redirect_to sign_in_path unless Current.user
  end
end
