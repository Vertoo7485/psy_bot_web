class CreateTests < ActiveRecord::Migration[7.1]
  def change
    create_table :tests do |t|
      t.string :title
      t.text :description
      t.string :category
      t.jsonb :questions
      t.jsonb :config

      t.timestamps
    end
  end
end
