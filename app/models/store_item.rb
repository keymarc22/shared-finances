class StoreItem < ApplicationRecord
  PACKAGES = %i[
    unit
    package
    box
    can
    bottle
    kilogram
    liter
    gram
  ]

  belongs_to :account

  has_many :item_prices, dependent: :destroy
  has_many :stores, through: :item_prices

  scope :by_barcode, ->(barcode) {
    where(barcode: barcode)
  }

  scope :by_name, ->(name) {
    where("name ILIKE ?", "%#{name}%")
  }

  validates :name, presence: true, uniqueness: { scope: :account_id }

  accepts_nested_attributes_for :item_prices, allow_destroy: true, reject_if: :all_blank

  def self.ransackable_attributes(auth_object = nil)
    [ "account_id", "barcode", "created_at", "id", "name", "package", "barcode", "updated_at" ]
  end

  def self.ransackable_associations(auth_object = nil)
    [ "account", "item_prices", "stores" ]
  end
end
