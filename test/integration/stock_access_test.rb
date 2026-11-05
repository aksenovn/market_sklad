require "test_helper"

class StockAccessTest < ActionDispatch::IntegrationTest
  setup do
    Rails.cache.clear
    @stock = stocks(:one)
  end

  test "guest cannot access stock pages" do
    stock_pages.each do |url|
      get url
      assert_redirected_to new_session_url
    end
  end

  test "customer cannot access stock pages" do
    sign_in_customer

    stock_pages.each do |url|
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

  def stock_pages
    [
      stocks_url,
      stock_url(@stock),
      new_stock_url,
      edit_stock_url(@stock)
    ]
  end

  def assert_json_access_denied(expected_status)
    get stocks_url(format: :json)
    assert_response expected_status

    get stock_url(@stock, format: :json)
    assert_response expected_status

    original_attributes = @stock.attributes

    assert_no_difference("Stock.count") do
      post stocks_url(format: :json), params: {
        stock: {
          warehouse_id: warehouses(:one).id,
          product_id: products(:two).id,
          quantity: 5,
          reserved_quantity: 0
        }
      }
      assert_response expected_status

      patch stock_url(@stock, format: :json),
            params: { stock: { quantity: 999 } }
      assert_response expected_status

      delete stock_url(@stock, format: :json)
      assert_response expected_status
    end

    assert_equal original_attributes, @stock.reload.attributes
  end
end
