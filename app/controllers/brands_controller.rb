class BrandsController < ApplicationController
  before_action :set_brand, only: %i[ show edit update destroy ]

  def index
    @brands = Brand.order(:name)
  end

  def show
  end

  def new
    @brand = Brand.new
  end

  def edit
  end

  def create
    @brand = Brand.new(brand_params)

    respond_to do |format|
      if @brand.save
        format.html { redirect_to @brand, notice: "Бренд создан." }
        format.json { render :show, status: :created, location: @brand }
      else
        format.html { render :new, status: :unprocessable_content }
        format.json { render json: @brand.errors, status: :unprocessable_content }
      end
    end
  end

  def update
    respond_to do |format|
      if @brand.update(brand_params)
        format.html do
          redirect_to @brand,
                      notice: "Бренд обновлён.",
                      status: :see_other
        end
        format.json { render :show, status: :ok, location: @brand }
      else
        format.html { render :edit, status: :unprocessable_content }
        format.json { render json: @brand.errors, status: :unprocessable_content }
      end
    end
  end

   def destroy
    respond_to do |format|
      if @brand.destroy
        format.html do
          redirect_to brands_path,
                      notice: "Бренд удалён.",
                      status: :see_other
        end
        format.json { head :no_content }
      else
        message = "Нельзя удалить бренд, пока с ним связаны товары."

        format.html do
          redirect_to @brand,
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

  def set_brand
    @brand = Brand.find(params.expect(:id))
  end

  def brand_params
    params.expect(brand: [ :name ])
  end
end
