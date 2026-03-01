class CreateMeditationSessions < ActiveRecord::Migration[7.1]
  def change
    create_table :meditation_sessions do |t|
      t.references :user, null: false, foreign_key: true
      t.integer :duration_minutes
      t.string :technique
      t.integer :rating
      t.text :notes
      t.datetime :completed_at

      t.timestamps
    end
  end
end
