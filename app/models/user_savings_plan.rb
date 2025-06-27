class UserSavingsPlan < ApplicationRecord
  belongs_to :user
  belongs_to :savings_plan
end