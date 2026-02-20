class CreateUserDayProgresses < ActiveRecord::Migration[7.1]
  def change
    create_table :user_day_progresses do |t|
      t.references :user, null: false, foreign_key: true
      t.references :day, null: false, foreign_key: true
      t.boolean :completed
      t.jsonb :answers
      t.datetime :started_at
      t.datetime :completed_at

      t.timestamps
    end
  end
end
