json.extract! stock, :id, :warehouse_id, :product_id, :quantity, :reserved_quantity, :created_at, :updated_at
json.url stock_url(stock, format: :json)
