require "test_helper"

class SupplyTest < ActiveSupport::TestCase
  test "receiving rolls back stock changes if saving the status fails" do
    supply = supplies(:one)
    stock = stocks(:one)
    original_quantity = stock.quantity

    supply.define_singleton_method(:update!) do |**_attributes|
      raise ActiveRecord::RecordInvalid, self
    end

    assert_raises(ActiveRecord::RecordInvalid) do
      supply.receive!
    end

    assert_equal original_quantity, stock.reload.quantity
    assert supply.reload.draft?
  end
end
