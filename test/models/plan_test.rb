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

require "test_helper"

class PlanTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
