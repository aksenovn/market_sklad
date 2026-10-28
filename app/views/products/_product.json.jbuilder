json.extract! product, :id, :name, :sku, :description, :price, :active, :category_id, :brand_id, :created_at, :updated_at
json.url product_url(product, format: :json)
