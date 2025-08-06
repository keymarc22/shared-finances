FactoryBot.define do
  factory :user do
    name { Faker::Name.name }
    email { Faker::Internet.email }
    percentage { rand(1..100) }
    password { '12345678' }
    password_confirmation { '12345678' }
    account
  end
end
