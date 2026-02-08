class AddSubscriptionToUsers < ActiveRecord::Migration[8.1]
  def change
    add_column :users, :trial_ends_at, :datetime
    add_column :users, :subscribed, :boolean
  end
end
