class StocksController < ApplicationController
  before_action :require_employee
  before_action :set_stock, only: %i[ show edit update destroy ]

  def index
    @stocks = Stock.includes(:warehouse, :product).order(:warehouse_id, :product_id)
  end

  def show
  end

  def new
    @stock = Stock.new
  end

  def edit
  end

  def create
    @stock = Stock.new(stock_params)

    respond_to do |format|
      if @stock.save
        format.html { redirect_to @stock, notice: "Остаток добавлен." }
        format.json { render :show, status: :created, location: @stock }
      else
        format.html { render :new, status: :unprocessable_content }
        format.json { render json: @stock.errors, status: :unprocessable_content }
      end
    end
  end

  def update
    respond_to do |format|
      if @stock.update(stock_params)
        format.html do
          redirect_to @stock,
                      notice: "Остаток обновлён.",
                      status: :see_other
        end
        format.json { render :show, status: :ok, location: @stock }
      else
        format.html { render :edit, status: :unprocessable_content }
        format.json { render json: @stock.errors, status: :unprocessable_content }
      end
    end
  end

  def destroy
    respond_to do |format|
      if @stock.destroy
        format.html do
          redirect_to stocks_path,
                      notice: "Запись остатка удалена.",
                      status: :see_other
        end
        format.json { head :no_content }
      else
        message = "Нельзя удалить запись с физическим остатком или резервом."

        format.html do
          redirect_to @stock, alert: message, status: :see_other
        end
        format.json do
          render json: { errors: [ message ] },
                 status: :unprocessable_content
        end
      end
    end
  end

  private

  def set_stock
    @stock = Stock.find(params.expect(:id))
  end

  def stock_params
    params.expect(stock: [ :warehouse_id, :product_id, :quantity, :reserved_quantity ])
  end
end
