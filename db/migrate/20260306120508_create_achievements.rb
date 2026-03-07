class CreateAchievements < ActiveRecord::Migration[7.1]
  def change
    create_table :achievements do |t|
      t.string :title
      t.text :description
      t.string :icon
      t.string :rarity
      t.jsonb :condition

      t.timestamps
    end
  end
end
