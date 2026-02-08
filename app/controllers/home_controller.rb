class HomeController < ApplicationController
  skip_before_action :authenticate!, only: [:show, :notify_test, :email_notify_test, :landing]

  # Public SaaS landing page
  def landing
  end

  def show
  end

  # Test action for DaisyUI in-app notification
  def notify_test
    flash[:notice] = "This is a DaisyUI in-app notification!"
    redirect_to root_path
  end

  # Test action for email notification
  def email_notify_test
    user = Current.user || User.first
    if user&.email.present?
      NotificationMailer.notification(user, "Test Email Notification", "This is a test email notification from DraftEasy.").deliver_now
      flash[:notice] = "Test email sent to #{user.email}."
    else
      flash[:alert] = "No user with email found to send test email."
    end
    redirect_to root_path
  end
end
