require "test_helper"

class WarehouseTest < ActiveSupport::TestCase
  test "name and address are required" do
    warehouse = Warehouse.new(name: "  ", address: "  ")

    assert_not warehouse.valid?
    assert_includes warehouse.errors[:name], "Укажите название склада"
    assert_includes warehouse.errors[:address], "Укажите адрес склада"
  end

  test "duplicate name is rejected after trimming spaces" do
    warehouse = Warehouse.new(
      name: " #{warehouses(:one).name} ",
      address: "Другой адрес"
    )

    assert_not warehouse.valid?
    assert_includes warehouse.errors[:name],
                    "Склад с таким названием уже существует"
  end

  test "name and address have length limits" do
    warehouse = Warehouse.new(name: "А" * 101, address: "Б" * 256)

    assert_not warehouse.valid?
    assert warehouse.errors[:name].any?
    assert warehouse.errors[:address].any?
  end

  test "spaces around name and address are removed" do
    warehouse = Warehouse.create!(
      name: " Новый склад ",
      address: " Москва, Примерная улица, 10 "
    )

    assert_equal "Новый склад", warehouse.reload.name
    assert_equal "Москва, Примерная улица, 10", warehouse.address
  end
end
