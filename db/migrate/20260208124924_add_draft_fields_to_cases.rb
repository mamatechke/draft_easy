class AddDraftFieldsToCases < ActiveRecord::Migration[8.1]
  def change
    add_column :cases, :draft_content, :text
    add_column :cases, :draft_style, :string
  end
end
