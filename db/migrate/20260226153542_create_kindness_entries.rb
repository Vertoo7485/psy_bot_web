class CreateKindnessEntries < ActiveRecord::Migration[7.1]
  def change
    create_table :kindness_entries do |t|
      t.references :user, null: false, foreign_key: true
      t.date :entry_date
      t.text :act
      t.text :reaction
      t.text :feelings

      t.timestamps
    end
  end
end
