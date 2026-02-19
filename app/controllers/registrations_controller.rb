class RegistrationsController < ApplicationController
  layout "authentification"
  skip_before_action :authenticate!

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params.merge(trial_ends_at: 30.days.from_now))

    if @user.save
      session_record = @user.sessions.create!
      cookies.signed.permanent[:session_token] = {value: session_record.id, httponly: true}

      send_email_verification
      redirect_to dashboard_path, notice: "Welcome! You have signed up successfully. Your free trial starts now."
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.permit(:email, :password, :password_confirmation, :trial_ends_at, :subscribed)
  end

  def send_email_verification
    UserMailer.with(user: @user).email_verification.deliver_later
  end
end
