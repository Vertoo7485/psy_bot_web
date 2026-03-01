class CreateFearConquests < ActiveRecord::Migration[7.1]
  def change
    create_table :fear_conquests do |t|
      t.references :user, null: false, foreign_key: true
      t.datetime :conquered_at
      t.string :category
      t.string :action
      t.text :micro_steps
      t.text :reflection

      t.timestamps
    end
  end
end
