class ProductsController < ApplicationController
  before_action :set_product, only: %i[ show edit update destroy ]

  def index
    @categories = Category.order(:name)
    @brands = Brand.order(:name)

    @query = params[:q].to_s.strip
    @category_id = params[:category_id].to_s
    @brand_id = params[:brand_id].to_s
    @status = params[:status].to_s
    @sort = params[:sort].to_s

    @products = Product.includes(:category, :brand)

    if @query.present?
        pattern = "%#{Product.sanitize_sql_like(@query.downcase)}%"

      @products = @products.where(
        "products.search_text LIKE ?",
        pattern
      )
    end

    if @category_id.present?
      @products = @products.where(category_id: @category_id)
    end

    if @brand_id.present?
      @products = @products.where(brand_id: @brand_id)
    end

    case @status
    when "active"
      @products = @products.where(active: true)
    when "archived"
      @products = @products.where(active: false)
    end

    @products = case @sort
    when "price_asc"
      @products.order(price: :asc, id: :asc)
    when "price_desc"
      @products.order(price: :desc, id: :asc)
    else
      @products.order(name: :asc, id: :asc)
    end
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
