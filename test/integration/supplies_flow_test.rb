require "test_helper"

class SuppliesFlowTest < ActionDispatch::IntegrationTest
  test "employee creates a draft and adds a product without changing stock" do
    Rails.cache.clear
    post session_url, params: {
      session: {
        email_address: users(:employee).email_address,
        password: "TestPassword123"
      }
    }
    assert_redirected_to root_url

    before_stocks = Stock.order(:id).pluck(:id, :quantity, :reserved_quantity)

    assert_difference("Supply.count", 1) do
      post supplies_url, params: {
        supply: {
          supplier_id: suppliers(:one).id,
          warehouse_id: warehouses(:one).id,
          notes: "Тестовая поставка",
          status: "received"
        }
      }
    end

    supply = Supply.find_by!(notes: "Тестовая поставка")
    assert supply.draft?
    assert_redirected_to supply_url(supply)
    follow_redirect!
    assert_select "form[action=?]", supply_supply_items_path(supply)

    item_params = {
      supply_item: {
        product_id: products(:one).id,
        quantity: 3,
        purchase_price: "120.50"
      }
    }

    assert_difference("SupplyItem.count", 1) do
      post supply_supply_items_url(supply), params: item_params
    end

    assert_redirected_to supply_url(supply)
    follow_redirect!
    assert_select "li", text: /#{Regexp.escape(products(:one).name)}/
    assert_equal 3, supply.supply_items.sole.quantity

    assert_no_difference("SupplyItem.count") do
      post supply_supply_items_url(supply), params: item_params
    end

    assert_response :unprocessable_content
    assert_select ".flash-alert", text: /Этот товар уже добавлен в поставку/
    assert_equal before_stocks, Stock.order(:id).pluck(:id, :quantity, :reserved_quantity)
  end
end
