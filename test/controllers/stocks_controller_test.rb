require "test_helper"

class StocksControllerTest < ActionDispatch::IntegrationTest
  setup do
    Rails.cache.clear

    post session_url, params: {
      session: {
        email_address: users(:employee).email_address,
        password: "TestPassword123"
      }
    }

    assert_redirected_to root_url

    @stock = stocks(:one)
  end

  test "should get index" do
    get stocks_url
    assert_response :success
  end

  test "should get new" do
    get new_stock_url
    assert_response :success
  end

    test "should create stock" do
    assert_difference("Stock.count", 1) do
      post stocks_url, params: {
        stock: {
          warehouse_id: warehouses(:one).id,
          product_id: products(:two).id,
          quantity: 7,
          reserved_quantity: 0
        }
      }
    end

    assert_redirected_to stock_url(Stock.last)
  end


  test "should show stock" do
    get stock_url(@stock)
    assert_response :success
  end

  test "should get edit" do
    get edit_stock_url(@stock)
    assert_response :success
  end

  test "should update stock" do
    patch stock_url(@stock), params: { stock: { product_id: @stock.product_id, quantity: @stock.quantity, reserved_quantity: @stock.reserved_quantity, warehouse_id: @stock.warehouse_id } }
    assert_redirected_to stock_url(@stock)
  end

   test "should destroy empty stock" do
    @stock.update!(quantity: 0, reserved_quantity: 0)

    assert_difference("Stock.count", -1) do
      delete stock_url(@stock)
    end

    assert_redirected_to stocks_url
  end

  test "should not destroy stock with quantity or reserve" do
    original_attributes = @stock.attributes

    assert_no_difference("Stock.count") do
      delete stock_url(@stock)
    end

    assert_redirected_to stock_url(@stock)
    assert_equal "Нельзя удалить запись с физическим остатком или резервом.",
                 flash[:alert]
    assert_equal original_attributes, @stock.reload.attributes
  end
end
