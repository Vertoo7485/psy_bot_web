class AddSubscriptionFieldsToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :access_level, :string
    add_column :users, :is_active, :boolean
    add_column :users, :subscription_ends_at, :datetime
    add_column :users, :trial_ends_at, :datetime
    add_column :users, :premium_activated_at, :datetime
  end
end
