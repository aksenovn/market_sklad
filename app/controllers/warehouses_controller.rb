class WarehousesController < ApplicationController
  before_action :require_employee
  before_action :set_warehouse, only: %i[ show edit update destroy ]

  def index
    @warehouses = Warehouse.order(:name)
  end

  def show
  end

  def new
    @warehouse = Warehouse.new
  end

  def edit
  end

  def create
    @warehouse = Warehouse.new(warehouse_params)

    respond_to do |format|
      if @warehouse.save
        format.html { redirect_to @warehouse, notice: "Склад создан." }
        format.json { render :show, status: :created, location: @warehouse }
      else
        format.html { render :new, status: :unprocessable_content }
        format.json { render json: @warehouse.errors, status: :unprocessable_content }
      end
    end
  end

  def update
    respond_to do |format|
      if @warehouse.update(warehouse_params)
        format.html do
          redirect_to @warehouse,
                      notice: "Склад обновлён.",
                      status: :see_other
        end
        format.json { render :show, status: :ok, location: @warehouse }
      else
        format.html { render :edit, status: :unprocessable_content }
        format.json { render json: @warehouse.errors, status: :unprocessable_content }
      end
    end
  end

   def destroy
    respond_to do |format|
      if @warehouse.destroy
        format.html do
          redirect_to warehouses_path,
                      notice: "Склад удалён.",
                      status: :see_other
        end
        format.json { head :no_content }
      else
        message = if @warehouse.supplies.exists?
          "Нельзя удалить склад, пока с ним связаны поставки."
        else
          "Нельзя удалить склад, пока с ним связаны остатки товаров."
        end

        format.html do
          redirect_to @warehouse,
                      alert: message,
                      status: :see_other
        end
        format.json do
          render json: { errors: [ message ] },
                 status: :unprocessable_content
        end
      end
    end
  end

  private

  def set_warehouse
    @warehouse = Warehouse.find(params.expect(:id))
  end

  def warehouse_params
    params.expect(warehouse: [ :name, :address ])
  end
end
