require "test_helper"

class SuppliersControllerTest < ActionDispatch::IntegrationTest
    setup do
    Rails.cache.clear

    post session_url, params: {
      session: {
        email_address: users(:employee).email_address,
        password: "TestPassword123"
      }
    }

    assert_redirected_to root_url

    @supplier = suppliers(:one)
  end

  test "should get index" do
    get suppliers_url
    assert_response :success
  end

  test "should get new" do
    get new_supplier_url
    assert_response :success
  end

  test "should create supplier" do
    assert_difference("Supplier.count", 1) do
      post suppliers_url, params: {
        supplier: { name: "Поставщик канцтоваров" }
      }
    end

    supplier = Supplier.find_by!(name: "Поставщик канцтоваров")
    assert_redirected_to supplier_url(supplier)
  end

  test "should show supplier" do
    get supplier_url(@supplier)
    assert_response :success
  end

  test "should get edit" do
    get edit_supplier_url(@supplier)
    assert_response :success
  end

  test "should update supplier" do
    patch supplier_url(@supplier), params: { supplier: { email: @supplier.email, name: @supplier.name, phone: @supplier.phone } }
    assert_redirected_to supplier_url(@supplier)
  end

    test "should destroy unused supplier" do
    supplier = Supplier.create!(name: "Временный поставщик")

    assert_difference("Supplier.count", -1) do
      delete supplier_url(supplier)
    end

    assert_redirected_to suppliers_url
  end

  test "should not destroy supplier with supplies" do
    assert_no_difference([ "Supplier.count", "Supply.count" ]) do
      delete supplier_url(@supplier)
    end

    assert_redirected_to supplier_url(@supplier)
    assert_equal "Нельзя удалить поставщика, пока с ним связаны поставки.",
                 flash[:alert]
  end
end
