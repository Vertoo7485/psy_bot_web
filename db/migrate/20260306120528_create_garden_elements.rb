class CreateGardenElements < ActiveRecord::Migration[7.1]
  def change
    create_table :garden_elements do |t|
      t.references :user, null: false, foreign_key: true
      t.string :element_type
      t.integer :position_x
      t.integer :position_y
      t.datetime :unlocked_at
      t.jsonb :metadata

      t.timestamps
    end
  end
end
