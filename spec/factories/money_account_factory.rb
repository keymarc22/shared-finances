FactoryBot.define do
  factory :money_account do
    name { Faker::Bank.name }
    association :user
  end
end
