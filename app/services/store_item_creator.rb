class StoreItemCreator
  def self.build(account, attributes)
    new(account, attributes)._build
  end

  def _build
    store_item = account.store_items.by_name(attributes[:name]).first_or_initialize
    @attributes.delete(:package) if attributes[:package].blank?
    store_item.assign_attributes(attributes)

    store_item
  end

  private

  attr_reader :account, :attributes

  def initialize(account, attributes)
    @account = account
    @attributes = attributes
  end
end
