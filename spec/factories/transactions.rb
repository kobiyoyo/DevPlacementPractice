FactoryBot.define do
  factory :transaction do
    type { "" }
    description { "MyString" }
    amount { "MyString" }
    status { "MyString" }
    confirm { false }
    user { nil }
    wallet { nil }
  end
end
