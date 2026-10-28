require "test_helper"

class ProductsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @product = products(:one)
  end

  test "should get index" do
    get products_url
    assert_response :success
  end

  test "should get new" do
    get new_product_url
    assert_response :success
  end

    test "should create product" do
    assert_difference("Product.count", 1) do
      post products_url, params: {
        product: {
          name: "Новый смартфон",
          sku: "NEW-001",
          description: "Описание нового товара",
          price: "30000.00",
          active: true,
          category_id: @product.category_id,
          brand_id: @product.brand_id
        }
      }
    end

    assert_redirected_to product_url(Product.last)
  end

  test "should show product" do
    get product_url(@product)
    assert_response :success
  end

  test "should get edit" do
    get edit_product_url(@product)
    assert_response :success
  end

  test "should update product" do
    patch product_url(@product), params: { product: { active: @product.active, brand_id: @product.brand_id, category_id: @product.category_id, description: @product.description, name: @product.name, price: @product.price, sku: @product.sku } }
    assert_redirected_to product_url(@product)
  end

  test "should archive product" do
    assert_no_difference("Product.count") do
      delete product_url(@product)
    end

    assert_redirected_to products_url
    assert_not @product.reload.active?
  end
end
