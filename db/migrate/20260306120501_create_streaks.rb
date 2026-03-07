class CreateStreaks < ActiveRecord::Migration[7.1]
  def change
    create_table :streaks do |t|
      t.references :user, null: false, foreign_key: true
      t.integer :current_streak
      t.integer :longest_streak
      t.datetime :last_activity_at

      t.timestamps
    end
  end
end
