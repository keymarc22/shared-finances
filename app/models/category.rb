class Category < ApplicationRecord
  enum :category_type, {
    expense: 0,
    savings: 1,
    both: 2
  }
end
