class Currency < ApplicationRecord
	#Relationship
	has_many :wallets

    #Validation
	validates :name, presence: true
    validates :abbreviation, presence: true, length: { minimum: 3 }
end
