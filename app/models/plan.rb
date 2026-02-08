# == Schema Information
#
# Table name: plans
#
#  id              :integer          not null, primary key
#  name            :string
#  stripe_price_id :string
#  amount          :integer
#  currency        :string
#  interval        :string
#  features        :text
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

class Plan < ApplicationRecord
  has_many :users

  def price_in_cents
    amount
  end

  def price_in_dollars
    amount / 100.0
  end
end
