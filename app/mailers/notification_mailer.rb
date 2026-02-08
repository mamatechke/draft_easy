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
end
