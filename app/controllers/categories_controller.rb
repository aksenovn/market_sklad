class CategoriesController < ApplicationController
  before_action :set_category, only: %i[ show edit update destroy ]

  def index
    @categories = Category.order(:name)
  end

  def show
  end

  def new
    @category = Category.new
  end

  def edit
  end

  def create
    @category = Category.new(category_params)

    respond_to do |format|
      if @category.save
        format.html { redirect_to @category, notice: "Категория создана." }
        format.json { render :show, status: :created, location: @category }
      else
        format.html { render :new, status: :unprocessable_content }
        format.json { render json: @category.errors, status: :unprocessable_content }
      end
    end
  end

  def update
    respond_to do |format|
      if @category.update(category_params)
        format.html do
          redirect_to @category,
                      notice: "Категория обновлена.",
                      status: :see_other
        end
        format.json { render :show, status: :ok, location: @category }
      else
        format.html { render :edit, status: :unprocessable_content }
        format.json { render json: @category.errors, status: :unprocessable_content }
      end
    end
  end

  def destroy
    @category.destroy!

    respond_to do |format|
      format.html do
        redirect_to categories_path,
                    notice: "Категория удалена.",
                    status: :see_other
      end
      format.json { head :no_content }
    end
  end

  private

  def set_category
    @category = Category.find(params.expect(:id))
  end

  def category_params
    params.expect(category: [ :name, :description ])
  end
end