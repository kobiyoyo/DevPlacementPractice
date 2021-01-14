class CreateTransactions < ActiveRecord::Migration[6.0]
  def change
    create_table :transactions do |t|
      t.integer :type
      t.string :description
      t.decimal :amount, precision: 8, scale: 2
      t.string :status
      t.boolean :confirm
      t.references :user, null: false, foreign_key: true
      t.references :wallet, null: false, foreign_key: true

      t.timestamps
    end
  end
end
