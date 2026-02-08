class ReminderJob < ApplicationJob
  queue_as :default

  def perform(case_id)
    case_record = Case.find(case_id)
    user = case_record.user
    NotificationMailer.reminder(user, case_record).deliver_now
  end
end
