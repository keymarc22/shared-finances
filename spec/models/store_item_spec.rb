require 'rails_helper'

RSpec.describe StoreItem, type: :model do
  let(:account) { create(:account, name: "Cuenta test") }

  it "is valid with valid attributes" do
    item = StoreItem.new(name: "Producto", package: "unit", barcode: "123456", account: account)
    expect(item).to be_valid
  end

  it "is invalid without name" do
    item = StoreItem.new(package: "unit", barcode: "123456", account: account)
    expect(item).not_to be_valid
    expect(item.errors[:name]).to be_present
  end

  it "is invalid with duplicate name in same account" do
    StoreItem.create!(name: "Producto", package: "unit", barcode: "123456", account: account)
    item = StoreItem.new(name: "Producto", package: "unit", barcode: "654321", account: account)
    expect(item).not_to be_valid
    expect(item.errors[:name]).to be_present
  end

  it "finds by barcode" do
    item = StoreItem.create!(name: "Producto", package: "unit", barcode: "123456", account: account)
    expect(StoreItem.by_barcode("123456")).to include(item)
  end
end