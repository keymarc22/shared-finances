FactoryBot.define do
  factory :store_item do
    name { "Producto" }
    package { "unit" }
    barcode { "123456" }
    association :account
  end
end
