class CreateUserPrograms < ActiveRecord::Migration[7.1]
  def change
    create_table :user_programs do |t|
      t.references :user, null: false, foreign_key: true
      t.references :program, null: false, foreign_key: true
      t.datetime :started_at
      t.datetime :completed_at
      t.integer :current_day

      t.timestamps
    end
  end
end
