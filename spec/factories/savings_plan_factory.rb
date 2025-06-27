FactoryBot.define do
  factory :savings_plan do
    name { Faker::Commerce.product_name }
    target_amount { Faker::Number.decimal(l_digits: 2, r_digits: 2) }
    deadline { Date.current + 30.days }
    status { :active }
    plan_type { :personal }
    association :money_account

    trait :with_users do
      after(:create) do |savings_plan|
        create_list(:user_savings_plan, 2, savings_plan: savings_plan)
      end
    end

    factory :shared_savings_plan, parent: :savings_plan do
      plan_type { :shared }
    end

    factory :personal_savings_plan, parent: :savings_plan do
      plan_type { :personal }
    end

    factory :completed_savings_plan, parent: :savings_plan do
      status { :completed }
    end

    factory :paused_savings_plan, parent: :savings_plan do
      status { :paused }
    end

    factory :cancelled_savings_plan, parent: :savings_plan do
      status { :cancelled }
    end
  end

  factory :user_savings_plan do
    association :user
    association :savings_plan
  end

  factory :savings_plan_with_incomings, parent: :savings_plan do
    after(:create) do |savings_plan|
      create_list(:incoming, 2, savings_plan: savings_plan)
    end
  end

  factory :savings_plan_with_expenses, parent: :savings_plan do
    after(:create) do |savings_plan|
      create_list(:expense, 2, savings_plan: savings_plan)
    end
  end
end