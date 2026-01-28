class AddExtractedTextToCases < ActiveRecord::Migration[7.0]
  def change
    add_column :cases, :extracted_text, :text
  end
end
