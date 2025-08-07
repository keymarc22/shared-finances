class ItemPrice < ApplicationRecord
  monetize :amount_cents

  belongs_to :store_item
  belongs_to :store

  validates :amount_cents, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :store_item, uniqueness: { scope: :store, message: "should have a unique price per store" }

  accepts_nested_attributes_for :store, allow_destroy: true, reject_if: :all_blank

  def self.ransackable_attributes(auth_object = nil)
    [ "amount_cents", "amount_currency", "created_at", "id", "store_id", "store_item_id", "updated_at" ]
  end

  def self.ransackable_associations(auth_object = nil)
    [ "store", "store_item" ]
  end
end
