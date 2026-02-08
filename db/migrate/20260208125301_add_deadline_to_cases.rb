class AddDeadlineToCases < ActiveRecord::Migration[8.1]
  def change
    add_column :cases, :deadline, :date
  end
end
