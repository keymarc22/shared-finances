FactoryBot.define do
  factory :category do
    name { Faker::Commerce.department }
    category_type { :expense }
  end
end
