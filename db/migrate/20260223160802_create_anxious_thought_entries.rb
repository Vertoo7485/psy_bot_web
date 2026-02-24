class CreateAnxiousThoughtEntries < ActiveRecord::Migration[7.1]
  def change
    create_table :anxious_thought_entries do |t|
      t.references :user, null: false, foreign_key: true
      t.text :thought
      t.integer :probability
      t.text :facts_pro
      t.text :facts_con
      t.text :reframe
      t.date :entry_date

      t.timestamps
    end
  end
end
