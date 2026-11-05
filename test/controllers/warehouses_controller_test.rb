require "test_helper"

class WarehousesControllerTest < ActionDispatch::IntegrationTest
  setup do
    Rails.cache.clear

    post session_url, params: {
      session: {
        email_address: users(:employee).email_address,
        password: "TestPassword123"
      }
    }

    assert_redirected_to root_url

    @warehouse = warehouses(:one)
  end

  test "should get index" do
    get warehouses_url
    assert_response :success
  end

  test "should get new" do
    get new_warehouse_url
    assert_response :success
  end

  test "should create warehouse" do
    assert_difference("Warehouse.count", 1) do
      post warehouses_url, params: {
        warehouse: {
          name: "Новый склад",
          address: "Москва, Примерная улица, 10"
        }
      }
    end

    assert_redirected_to warehouse_url(Warehouse.last)
  end

  test "should show warehouse" do
    get warehouse_url(@warehouse)
    assert_response :success
  end

  test "should get edit" do
    get edit_warehouse_url(@warehouse)
    assert_response :success
  end

  test "should update warehouse" do
    patch warehouse_url(@warehouse), params: { warehouse: { address: @warehouse.address, name: @warehouse.name } }
    assert_redirected_to warehouse_url(@warehouse)
  end

    test "should destroy unused warehouse" do
    warehouse = Warehouse.create!(
      name: "Временный склад",
      address: "Москва, Примерная улица, 10"
    )

    assert_difference("Warehouse.count", -1) do
      delete warehouse_url(warehouse)
    end

    assert_redirected_to warehouses_url
  end

  test "should not destroy warehouse with stocks" do
    assert_no_difference([ "Warehouse.count", "Stock.count" ]) do
      delete warehouse_url(@warehouse)
    end

    assert_redirected_to warehouse_url(@warehouse)
    assert_equal "Нельзя удалить склад, пока с ним связаны остатки товаров.",
                 flash[:alert]
  end
end
