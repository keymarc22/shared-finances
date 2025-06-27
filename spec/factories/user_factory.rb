FactoryBot.define do
  factory :user do
    name { Faker::Name.name }
    email { Faker::Internet.email }
    percentage { rand(1..100) }
    password { 'password' }
    password_confirmation { 'password' }
  end
end
