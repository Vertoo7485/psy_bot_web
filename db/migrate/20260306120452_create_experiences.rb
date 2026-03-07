class CreateExperiences < ActiveRecord::Migration[7.1]
  def change
    create_table :experiences do |t|
      t.references :user, null: false, foreign_key: true
      t.integer :total_points
      t.integer :level
      t.integer :next_level_at

      t.timestamps
    end
  end
end
