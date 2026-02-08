class TrialExpirationNotifierJob < ApplicationJob
  queue_as :default

  def perform(*args)
    # Find users whose trial expires in 3 days
    expiring_users = User.where(trial_ends_at: 3.days.from_now.beginning_of_day..3.days.from_now.end_of_day)
                         .where(subscribed: false)

    expiring_users.each do |user|
      NotificationMailer.trial_expiring(user).deliver_later
    end

    # Find users whose trial has expired
    expired_users = User.where("trial_ends_at < ?", Time.current)
                        .where(subscribed: false)

    expired_users.each do |user|
      NotificationMailer.trial_expired(user).deliver_later
    end
  end
end
