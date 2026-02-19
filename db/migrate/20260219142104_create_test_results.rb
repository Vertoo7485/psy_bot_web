class CreateTestResults < ActiveRecord::Migration[7.1]
  def change
    create_table :test_results do |t|
      t.references :user, null: false, foreign_key: true
      t.references :test, null: false, foreign_key: true
      t.jsonb :answers
      t.integer :score
      t.text :interpretation
      t.datetime :started_at
      t.datetime :completed_at

      t.timestamps
    end
  end
end
