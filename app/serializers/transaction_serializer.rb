class TransactionSerializer < ActiveModel::Serializer
  attributes :id, :type, :description, :amount, :status, :confirm
  has_one :user
  has_one :wallet
end
