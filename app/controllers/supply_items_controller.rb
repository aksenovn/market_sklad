class SupplyItemsController < ApplicationController
  before_action :require_employee

  def create
    @supply = Supply.find(params.expect(:supply_id))

    unless @supply.draft?
      redirect_to @supply, alert: "Можно менять только черновик поставки.",
                  status: :see_other
      return
    end

    @item = @supply.supply_items.build(item_params)

    if @item.save
      redirect_to @supply, notice: "Товар добавлен в поставку.",
                  status: :see_other
    else
      @products = Product.where(active: true).order(:name, :sku)
      render "supplies/show", status: :unprocessable_content
    end
  end

  private

  def item_params
    params.expect(supply_item: [ :product_id, :quantity, :purchase_price ])
  end
end
