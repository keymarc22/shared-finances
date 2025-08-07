class ItemPricesController < ApplicationController
  def index
    @q = current_account.item_prices.eager_load(:store, :store_item).ransack(search_params[:q])
    @item_prices = @q.result(distinct: true)
  end

  def barcode_reader; end

  def destroy
    @item_price = current_account.item_prices.find(params[:id])
    @item_price.destroy
    flash.now[:notice] = "Item was successfully deleted."
  end

  private

  def search_params
    params.permit(:format, :page, %i[store_item_name_or_store_item_barcode_cont])
  end
end
