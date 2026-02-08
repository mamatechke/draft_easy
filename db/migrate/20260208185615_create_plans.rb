class CreatePlans < ActiveRecord::Migration[8.1]
  def change
    create_table :plans do |t|
      t.string :name
      t.string :stripe_price_id
      t.integer :amount
      t.string :currency
      t.string :interval
      t.text :features

      t.timestamps
    end
  end
end
