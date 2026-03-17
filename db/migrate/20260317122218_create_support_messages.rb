class CreateSupportMessages < ActiveRecord::Migration[7.1]
  def change
    create_table :support_messages do |t|
      t.string :name
      t.text :message
      t.integer :status
      t.datetime :read_at

      t.timestamps
    end
  end
end
