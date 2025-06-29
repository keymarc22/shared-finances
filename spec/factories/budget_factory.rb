FactoryBot.define do
  factory :budget do
    name          { Faker::Commerce.product_name }
    amount_cents  { Faker::Number.decimal(l_digits: 2, r_digits: 2) }
    start_date    { Date.current }
    end_date      { Date.current + 30.days }
    period        { :monthly }
    budget_type   { :personal }
    status        { :active }

    association :category

    factory :shared_budget do
      budget_type { :shared }
    end

    trait :with_users do
      after(:create) do |budget|
        create_list(:budget_user, 2, budget: budget)
      end
    end
  end

  factory :budget_user do
    association :budget
    association :user
  end
end
