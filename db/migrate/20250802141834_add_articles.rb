class AddArticles < ActiveRecord::Migration[8.0]
  def change
    create_table :store_items do |t|
      t.string :name, null: false
      t.string :package, null: false
      t.string :barcode
      t.references :account

      t.timestamps
    end

    add_index :store_items, %i[account_id barcode], unique: true, where: "barcode IS NOT NULL AND barcode != ''"
    add_index :store_items, %i[account_id name], unique: true

    create_table :stores do |t|
      t.string :name, null: false
      t.string :address
      t.references :account

      t.timestamps
    end

    add_index :stores, %i[account_id name], unique: true

    create_table :item_prices do |t|
      t.references :store_item, null: false, foreign_key: true
      t.references :store, null: false, foreign_key: true

      t.timestamps
    end

    add_monetize :item_prices, :amount,  precision: 10, scale: 2, null: false
    add_index :item_prices, %i[store_id store_item_id], unique: true, name: 'index_item_prices_on_store_and_item'
  end
end
