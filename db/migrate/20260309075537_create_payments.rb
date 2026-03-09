class CreatePayments < ActiveRecord::Migration[7.1]
  def change
    create_table :payments do |t|
      t.references :user, null: false, foreign_key: true
      t.integer :amount
      t.string :currency
      t.string :status
      t.string :payment_type
      t.string :yookassa_id
      t.string :confirmation_url
      t.jsonb :metadata

      t.timestamps
    end
  end
end
