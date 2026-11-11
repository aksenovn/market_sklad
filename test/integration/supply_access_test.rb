require "test_helper"

class SupplyAccessTest < ActionDispatch::IntegrationTest
  test "guest cannot open supplies" do
    get supplies_url
    assert_redirected_to new_session_url

    get supply_url(supplies(:one), format: :json)
    assert_response :unauthorized
  end

  test "customer cannot open supplies or add a position" do
    Rails.cache.clear
    post session_url, params: {
      session: {
        email_address: users(:customer).email_address,
        password: "TestPassword123"
      }
    }
    assert_redirected_to root_url

    supply = supplies(:one)
    get supply_url(supply)
    assert_redirected_to root_url

    assert_no_difference("SupplyItem.count") do
      post supply_supply_items_url(supply, format: :json), params: {
        supply_item: {
          product_id: products(:two).id,
          quantity: 3,
          purchase_price: "100.00"
        }
      }
      assert_response :forbidden
    end
  end
end
