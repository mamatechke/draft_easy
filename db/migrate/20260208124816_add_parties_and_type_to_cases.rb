class AddPartiesAndTypeToCases < ActiveRecord::Migration[8.1]
  def change
    add_column :cases, :parties, :text
    add_column :cases, :case_type, :string
  end
end
