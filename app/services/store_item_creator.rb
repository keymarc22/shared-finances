class StoreItemCreator
  def self.build(account, attributes)
    new(account, attributes)._build
  end

  def _build
    store_item = account.store_items.by_barcode(attributes[:barcode]).first_or_initialize
    store_data = attributes.delete(:store)

    if store_data.present? # new store
      attributes[:item_prices_attributes]["0"][:store_attributes] = store_data
    end

    if attributes[:item_prices_attributes]["0"][:store_attributes]
      attributes[:item_prices_attributes]["0"][:store_attributes][:account_id] = account.id
    end

    store_item.assign_attributes(attributes)
    store_item
  end

  private

  attr_reader :account, :attributes

  def initialize(account, attributes)
    @account = account
    @attributes = attributes.to_unsafe_hash
  end
end
