class CreateWallets < ActiveRecord::Migration[6.0]
  def change
    create_table :wallets do |t|
      t.decimal :amount, precision: 8, scale: 2,default: 0
      t.boolean :main
      t.references :user, null: false, foreign_key: true
      t.references :currency, null: false, foreign_key: true

      t.timestamps
    end
  end
end
