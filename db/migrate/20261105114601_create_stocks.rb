class CreateStocks < ActiveRecord::Migration[8.1]
  def change
    create_table :stocks do |t|
      t.references :warehouse, null: false, foreign_key: true
      t.references :product, null: false, foreign_key: true
      t.integer :quantity, null: false, default: 0
      t.integer :reserved_quantity, null: false, default: 0

      t.timestamps
    end

    add_index :stocks, [ :warehouse_id, :product_id ], unique: true

    add_check_constraint :stocks,
                         "quantity >= 0",
                         name: "stocks_quantity_nonnegative"

    add_check_constraint :stocks,
                         "reserved_quantity >= 0",
                         name: "stocks_reserved_quantity_nonnegative"

    add_check_constraint :stocks,
                         "reserved_quantity <= quantity",
                         name: "stocks_reserved_within_quantity"
  end
end
