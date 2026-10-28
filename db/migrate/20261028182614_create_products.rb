class CreateProducts < ActiveRecord::Migration[8.1]
  def change
    create_table :products do |t|
      t.string :name, null: false
      t.string :sku, null: false
      t.text :description
      t.decimal :price, precision: 12, scale: 2, null: false
      t.boolean :active, default: true, null: false
      t.references :category, null: false, foreign_key: true
      t.references :brand, null: false, foreign_key: true

      t.timestamps
    end

    add_index :products, :sku, unique: true
    add_check_constraint :products, "price > 0",
                         name: "products_price_positive"
  end
end
