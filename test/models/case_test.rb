# == Schema Information
#
# Table name: cases
#
#  id                  :integer          not null, primary key
#  title               :string
#  description         :text
#  user_id             :integer          not null
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  case_name           :string
#  citation            :string
#  court               :string
#  jurisdiction        :string
#  decision_year       :integer
#  procedural_history  :text
#  facts               :text
#  legal_issue         :text
#  holding             :text
#  rule_of_law         :text
#  reasoning           :text
#  conclusion          :text
#  concurring_opinions :text
#  dissenting_opinions :text
#  extracted_text      :text
#  summary             :text
#  parties             :text
#  case_type           :string
#  draft_content       :text
#  draft_style         :string
#  deadline            :date
#
# Indexes
#
#  index_cases_on_user_id  (user_id)
#

require "test_helper"

class CaseTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
