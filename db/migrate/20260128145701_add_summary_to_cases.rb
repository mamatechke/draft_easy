class AddSummaryToCases < ActiveRecord::Migration[8.1]
  def change
    add_column :cases, :summary, :text
  end
end
