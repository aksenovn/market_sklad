class ProductsController < ApplicationController
  before_action :set_product, only: %i[ show edit update destroy ]

  def index
    @products = Product.includes(:category, :brand).order(:name)
  end

  def show
  end

  def new
    @product = Product.new
  end

  def edit
  end

  def create
    @product = Product.new(product_params)

    respond_to do |format|
      if @product.save
        format.html { redirect_to @product, notice: "Товар создан." }
        format.json { render :show, status: :created, location: @product }
      else
        format.html { render :new, status: :unprocessable_content }
        format.json { render json: @product.errors, status: :unprocessable_content }
      end
    end
  end

  def update
    respond_to do |format|
      if @product.update(product_params)
        format.html do
          redirect_to @product,
                      notice: "Товар обновлён.",
                      status: :see_other
        end
        format.json { render :show, status: :ok, location: @product }
      else
        format.html { render :edit, status: :unprocessable_content }
        format.json { render json: @product.errors, status: :unprocessable_content }
      end
    end
  end

  def destroy
    @product.update!(active: false)

    respond_to do |format|
      format.html do
        redirect_to products_path,
                    notice: "Товар перемещён в архив.",
                    status: :see_other
      end
      format.json { head :no_content }
    end
  end

  private

  def set_product
    @product = Product.find(params.expect(:id))
  end

  def product_params
    params.expect(product: [
      :name, :sku, :description, :price, :active, :category_id, :brand_id
    ])
  end
end
