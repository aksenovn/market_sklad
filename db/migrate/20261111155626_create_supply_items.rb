class CreateSupplyItems < ActiveRecord::Migration[8.1]
  def change
    create_table :supply_items do |t|
      t.references :supply, null: false, foreign_key: true
      t.references :product, null: false, foreign_key: true
      t.integer :quantity, null: false
      t.decimal :purchase_price, precision: 12, scale: 2, null: false

      t.timestamps

      t.index [ :supply_id, :product_id ], unique: true
      t.check_constraint "quantity > 0", name: "supply_items_quantity_positive"
      t.check_constraint "purchase_price >= 0", name: "supply_items_price_nonnegative"
    end
  end
end
