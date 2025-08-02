class Store < ApplicationRecord
  has_many :item_prices, dependent: :destroy
  has_many :store_items, through: :item_prices

  validates :name, uniqueness: { scope: :account_id, message: "should be unique per account" }, presence: true

  scope :by_name, ->(name) {
    where("name ILIKE ?", "%#{name}%")
  }
end
