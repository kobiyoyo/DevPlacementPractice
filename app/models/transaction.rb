class Transaction < ApplicationRecord

  #Transcation Type
  TYPE = %i[deposit withdraw].freeze
  enum type: TYPE


  #Relationship
  belongs_to :user
  belongs_to :wallet

  #Validation
  validates :type, presence: true
  validates :description, presence: true, length: { minimum: 10 }
  validates :amount, presence: true
  validates :status, presence: true
  validates :confirm, presence: true

  #Logic
    def check_user_role(params)
      if @current_user.admin?
        Transaction.new(params)
      else
        @current.transactions.build(params)
      end
    end 
end
