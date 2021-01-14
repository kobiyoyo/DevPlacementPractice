class CreateUsers < ActiveRecord::Migration[6.0]
  def change
    create_table :users do |t|
      t.string :first_name
      t.string :last_name
      t.string :email
      t.integer :role
      t.boolean :active ,default: true
      t.string :phone 
      t.string :password_digest

      t.timestamps
    end
  end
end
