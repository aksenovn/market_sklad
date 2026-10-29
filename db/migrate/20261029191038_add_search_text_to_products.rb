class AddSearchTextToProducts < ActiveRecord::Migration[8.1]
  def up
    add_column :products, :search_text, :text

    product_class = Class.new(ActiveRecord::Base) do
      self.table_name = "products"
    end

    product_class.reset_column_information

    product_class.find_each do |product|
      product.update_columns(
        search_text: "#{product.name} #{product.sku}".downcase
      )
    end
  end

  def down
    remove_column :products, :search_text
  end
end
