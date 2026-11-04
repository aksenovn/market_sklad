require "test_helper"

class WarehouseAccessTest < ActionDispatch::IntegrationTest
  setup do
    Rails.cache.clear
    @warehouse = warehouses(:one)
  end

  test "guest cannot access warehouse pages" do
    warehouse_pages.each do |url|
      get url
      assert_redirected_to new_session_url
    end
  end

  test "customer cannot access warehouse pages" do
    sign_in_customer

    warehouse_pages.each do |url|
      get url
      assert_redirected_to root_url
    end
  end

  test "guest JSON requests are rejected" do
    assert_json_access_denied(:unauthorized)
  end

  test "customer JSON requests are rejected" do
    sign_in_customer
    assert_json_access_denied(:forbidden)
  end

  private

  def sign_in_customer
    post session_url, params: {
      session: {
        email_address: users(:customer).email_address,
        password: "TestPassword123"
      }
    }

    assert_redirected_to root_url
  end

  def warehouse_pages
    [
      warehouses_url,
      warehouse_url(@warehouse),
      new_warehouse_url,
      edit_warehouse_url(@warehouse)
    ]
  end

  def assert_json_access_denied(expected_status)
    get warehouses_url(format: :json)
    assert_response expected_status

    get warehouse_url(@warehouse, format: :json)
    assert_response expected_status

    original_attributes = @warehouse.attributes

    assert_no_difference("Warehouse.count") do
      post warehouses_url(format: :json), params: {
        warehouse: {
          name: "Запрещённый склад",
          address: "Тестовый адрес"
        }
      }
      assert_response expected_status

      patch warehouse_url(@warehouse, format: :json), params: {
        warehouse: { name: "Запрещённое изменение" }
      }
      assert_response expected_status

      delete warehouse_url(@warehouse, format: :json)
      assert_response expected_status
    end

    assert_equal original_attributes, @warehouse.reload.attributes
  end
end
