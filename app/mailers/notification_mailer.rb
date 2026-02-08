class NotificationMailer < ApplicationMailer
  def notification(user, subject, message)
    @user = user
    @message = message
    mail to: @user.email, subject: subject
  end

  def reminder(user, case_record)
    @user = user
    @case = case_record
    mail to: @user.email, subject: "Deadline Reminder: #{@case.case_name}"
  end

  def trial_expiring(user)
    @user = user
    mail to: @user.email, subject: "Your trial expires in 3 days"
  end

  def trial_expired(user)
    @user = user
    mail to: @user.email, subject: "Your trial has expired"
  end
end
