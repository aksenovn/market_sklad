require "test_helper"

class SupplyReceivingTest < ActionDispatch::IntegrationTest
  setup do
    Rails.cache.clear
    post session_url, params: {
      session: {
        email_address: users(:employee).email_address,
        password: "TestPassword123"
      }
    }
    assert_redirected_to root_url
  end

  test "receiving updates stocks once and preserves the reserve" do
    supply = supplies(:one)
    existing = stocks(:one)
    original_quantity = existing.quantity
    original_reserve = existing.reserved_quantity
    incoming_quantity = supply_items(:one).quantity

    supply.supply_items.create!(
      product: products(:two), quantity: 4, purchase_price: "100.00"
    )

    assert_difference("Stock.count", 1) do
      post receive_supply_url(supply)
    end

    assert_redirected_to supply_url(supply)
    assert_equal "received", supply.reload.status
    assert_equal original_quantity + incoming_quantity, existing.reload.quantity
    assert_equal original_reserve, existing.reserved_quantity

    added = Stock.find_by!(warehouse: supply.warehouse, product: products(:two))
    assert_equal 4, added.quantity
    assert_equal 0, added.reserved_quantity

    before_retry = Stock.order(:id).pluck(:id, :quantity, :reserved_quantity)
    post receive_supply_url(supply)

    assert_redirected_to supply_url(supply)
    assert_equal "Эта поставка уже принята.", flash[:alert]
    assert_equal before_retry, Stock.order(:id).pluck(:id, :quantity, :reserved_quantity)
  end

  test "empty supply stays a draft and leaves stock unchanged" do
    supply = Supply.create!(supplier: suppliers(:one), warehouse: warehouses(:one))
    before_receiving = Stock.order(:id).pluck(:id, :quantity, :reserved_quantity)

    post receive_supply_url(supply)

    assert_redirected_to supply_url(supply)
    assert supply.reload.draft?
    assert_equal "Добавьте хотя бы один товар перед приёмкой.", flash[:alert]
    assert_equal before_receiving, Stock.order(:id).pluck(:id, :quantity, :reserved_quantity)
  end
end
