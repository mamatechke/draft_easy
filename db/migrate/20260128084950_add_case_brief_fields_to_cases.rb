class AddCaseBriefFieldsToCases < ActiveRecord::Migration[8.1]
  def change
    add_column :cases, :case_name, :string
    add_column :cases, :citation, :string
    add_column :cases, :court, :string
    add_column :cases, :jurisdiction, :string
    add_column :cases, :decision_year, :integer
    add_column :cases, :procedural_history, :text
    add_column :cases, :facts, :text
    add_column :cases, :legal_issue, :text
    add_column :cases, :holding, :text
    add_column :cases, :rule_of_law, :text
    add_column :cases, :reasoning, :text
    add_column :cases, :conclusion, :text
    add_column :cases, :concurring_opinions, :text
    add_column :cases, :dissenting_opinions, :text
  end
end
