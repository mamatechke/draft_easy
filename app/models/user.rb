# == Schema Information
#
# Table name: users
#
#  id              :integer          not null, primary key
#  admin           :boolean          default(FALSE), not null
#  email           :string           not null
#  first_name      :string           default(""), not null
#  last_name       :string           default(""), not null
#  password_digest :string           not null
#  verified        :boolean          default(FALSE), not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
# Indexes
#
#  index_users_on_email  (email) UNIQUE
#

class User < ApplicationRecord
  has_secure_password
  has_many :cases, dependent: :destroy
  belongs_to :plan, optional: true

  generates_token_for :email_verification, expires_in: 2.days do
    email
  end
  generates_token_for :password_reset, expires_in: 20.minutes do
    password_salt.last(10)
  end

  has_many :sessions, dependent: :destroy

  validates :email, presence: true, uniqueness: true, format: {with: URI::MailTo::EMAIL_REGEXP}
  validates :password, allow_nil: true, length: {minimum: 6}

  normalizes :email, with: -> { _1.strip.downcase }

  before_validation if: :email_changed?, on: :update do
    self.verified = false
  end

  after_update if: :password_digest_previously_changed? do
    sessions.where.not(id: Current.session).delete_all
  end

  before_create :set_trial_period

  def set_trial_period
    self.trial_ends_at = 30.days.from_now
    self.plan = Plan.find_by(name: "Free") # Assign free plan initially
  end

  def name_for_admin
    [first_name, last_name, "(#{email})"].join(" ")
  end

  def trial_active?
    trial_ends_at.present? && trial_ends_at > Time.current
  end

  def subscribed?
    subscribed
  end

  def can_access?
    trial_active? || subscribed?
  end

  def cases_limit
    plan&.name == "Pro" ? Float::INFINITY : 5
  end

  def precedent_searches_limit
    plan&.name == "Pro" ? Float::INFINITY : 1
  end

  def can_create_case?
    cases.count < cases_limit
  end

  def can_search_precedents?
    # For simplicity, check if they have searched less than limit today
    # In real app, track usage
    true # Placeholder
  end
end
