class SuppliesController < ApplicationController
  before_action :require_employee

  def index
    @supplies = Supply.includes(:supplier, :warehouse).order(created_at: :desc, id: :desc)
  end

  def show
    @supply = Supply.includes(:supplier, :warehouse, supply_items: :product)
                    .find(params.expect(:id))
    @item = SupplyItem.new
    @products = Product.where(active: true).order(:name, :sku)
  end

  def new
    @supply = Supply.new
    load_form_options
  end

  def create
    @supply = Supply.new(supply_params)

    if @supply.save
      redirect_to @supply, notice: "Черновик поставки создан.", status: :see_other
    else
      load_form_options
      render :new, status: :unprocessable_content
    end
  end

  private

  def load_form_options
    @suppliers = Supplier.order(:name)
    @warehouses = Warehouse.order(:name)
  end

  def supply_params
    params.expect(supply: [ :supplier_id, :warehouse_id, :notes ])
  end
end
