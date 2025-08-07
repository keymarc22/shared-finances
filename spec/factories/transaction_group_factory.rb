FactoryBot.define do
  factory :transaction_group do
    name { "Group #{rand(1000)}" }
    account
  end
end
