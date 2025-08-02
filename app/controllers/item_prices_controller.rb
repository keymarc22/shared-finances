class ItemPricesController < ApplicationController
  def index
    @q = current_account.item_prices.eager_load(:store, :store_item).ransack(params[:q])
    @item_prices = @q.result(distinct: true)
  end

  def barcode_reader; end
end
