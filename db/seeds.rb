# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
User.create(first_name: 'dan',last_name: 'adama',password:'enemona',email:'dan@gmail.com')
Currency.create(name:"US Dollars",abbreviation:"USD")
Currency.create(name:"Naira",abbreviation:"NGN")
Wallet.create(amount: 1000,main: true,user_id: 1,currency_id: 1)
Wallet.create(amount: 1000,main: false,user_id: 1,currency_id: 2)