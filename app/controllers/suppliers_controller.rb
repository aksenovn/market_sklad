class SuppliersController < ApplicationController
  before_action :require_employee
  before_action :set_supplier, only: %i[ show edit update destroy ]

  # GET /suppliers or /suppliers.json
  def index
    @suppliers = Supplier.order(:name)
  end

  # GET /suppliers/1 or /suppliers/1.json
  def show
  end

  # GET /suppliers/new
  def new
    @supplier = Supplier.new
  end

  # GET /suppliers/1/edit
  def edit
  end

  # POST /suppliers or /suppliers.json
  def create
    @supplier = Supplier.new(supplier_params)

    respond_to do |format|
      if @supplier.save
        format.html { redirect_to @supplier, notice: "Supplier was successfully created." }
        format.json { render :show, status: :created, location: @supplier }
      else
        format.html { render :new, status: :unprocessable_content }
        format.json { render json: @supplier.errors, status: :unprocessable_content }
      end
    end
  end

  # PATCH/PUT /suppliers/1 or /suppliers/1.json
  def update
    respond_to do |format|
      if @supplier.update(supplier_params)
        format.html { redirect_to @supplier, notice: "Данные поставщика обновлены.", status: :see_other }
        format.json { render :show, status: :ok, location: @supplier }
      else
        format.html { render :edit, status: :unprocessable_content }
        format.json { render json: @supplier.errors, status: :unprocessable_content }
      end
    end
  end

  # DELETE /suppliers/1 or /suppliers/1.json
  def destroy
    if @supplier.destroy
      respond_to do |format|
        format.html { redirect_to suppliers_path, notice: "Поставщик удалён.", status: :see_other }
        format.json { head :no_content }
      end
    else
      message = "Нельзя удалить поставщика, пока с ним связаны поставки."

      respond_to do |format|
        format.html { redirect_to @supplier, alert: message, status: :see_other }
        format.json { render json: { errors: [ message ] }, status: :unprocessable_content }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_supplier
      @supplier = Supplier.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def supplier_params
      params.expect(supplier: [ :name, :email, :phone ])
    end
end
