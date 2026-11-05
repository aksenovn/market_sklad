require "test_helper"

class StockTest < ActiveSupport::TestCase
  test "available quantity is physical quantity minus reserve" do
    assert_equal 8, stocks(:one).available_quantity
  end

  test "negative quantities are rejected" do
    stock = stocks(:one)
    stock.quantity = -1
    stock.reserved_quantity = -1

    assert_not stock.valid?
    assert stock.errors[:quantity].any?
    assert stock.errors[:reserved_quantity].any?
  end

  test "fractional quantities are rejected" do
    stock = stocks(:one)
    stock.quantity = "2.5"
    stock.reserved_quantity = "1.5"

    assert_not stock.valid?
    assert stock.errors[:quantity].any?
    assert stock.errors[:reserved_quantity].any?
  end

  test "reserve cannot exceed physical quantity" do
    stock = stocks(:one)
    stock.reserved_quantity = stock.quantity + 1

    assert_not stock.valid?
    assert_includes stock.errors[:reserved_quantity],
                    "Резерв не может превышать физическое количество"
  end

  test "warehouse and product pair must be unique" do
    existing = stocks(:one)

    stock = Stock.new(
      warehouse: existing.warehouse,
      product: existing.product,
      quantity: 3,
      reserved_quantity: 0
    )

    assert_not stock.valid?
    assert_includes stock.errors[:product_id],
                    "Этот товар уже добавлен на выбранный склад"
  end

  test "same product can be stored in another warehouse" do
    stock = Stock.new(
      warehouse: warehouses(:two),
      product: products(:one),
      quantity: 3,
      reserved_quantity: 0
    )

    assert stock.valid?
  end

  test "warehouse and product are required" do
    stock = Stock.new(quantity: 0, reserved_quantity: 0)

    assert_not stock.valid?
    assert stock.errors[:warehouse].any?
    assert stock.errors[:product].any?
  end
end
