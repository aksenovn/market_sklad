require "test_helper"

class RoleAccessTest < ActionDispatch::IntegrationTest
  setup do
    Rails.cache.clear
    @product = products(:one)
    @archived = products(:two)
    @archived.update!(active: false)
  end

  test "guest sees active products but cannot request archived products" do
    get products_url
    assert_response :success
    assert_select ".feature-card h2", text: @product.name
    assert_select ".feature-card h2", text: @archived.name, count: 0

    get products_url, params: { status: "archived" }
    assert_select ".feature-card", count: 0

    get product_url(@archived)
    assert_response :not_found

    get product_url(@archived, format: :json)
    assert_response :not_found
  end

  test "guest cannot open management forms" do
    management_urls.each do |url|
      get url
      assert_redirected_to new_session_url
    end
  end

  test "guest JSON changes are rejected without changing data" do
    assert_changes_blocked(:unauthorized)
  end

  test "customer cannot open management forms" do
    sign_in_as(:customer)

    management_urls.each do |url|
      get url
      assert_redirected_to root_url
    end
  end

  test "customer JSON changes are rejected without changing data" do
    sign_in_as(:customer)
    assert_changes_blocked(:forbidden)
  end

  test "customer cannot view archived products" do
    sign_in_as(:customer)

    get products_url
    assert_select ".feature-card h2", text: @archived.name, count: 0

    get product_url(@archived)
    assert_response :not_found

    get product_url(@archived, format: :json)
    assert_response :not_found
  end

  test "employee can view archived products" do
    sign_in_as(:employee)

    get product_url(@archived)
    assert_response :success

    get products_url, params: { status: "archived" }
    assert_select ".feature-card h2", text: @archived.name
  end

  private

  def sign_in_as(role)
    post session_url, params: {
      session: {
        email_address: users(role).email_address,
        password: "TestPassword123"
      }
    }

    assert_redirected_to root_url
  end

  def management_urls
    [
      new_product_url,
      edit_product_url(@product),
      new_category_url,
      edit_category_url(categories(:one)),
      new_brand_url,
      edit_brand_url(brands(:one))
    ]
  end

  def assert_changes_blocked(expected_status)
    records = [ @product, categories(:one), brands(:one) ]
    snapshots = records.map(&:attributes)

    assert_no_difference([ "Product.count", "Category.count", "Brand.count" ]) do
      post products_url(format: :json), params: {
        product: {
          name: "Запрещённый товар",
          sku: "FORBIDDEN-001",
          price: "100.00",
          active: true,
          category_id: categories(:one).id,
          brand_id: brands(:one).id
        }
      }
      assert_response expected_status

      patch product_url(@product, format: :json),
            params: { product: { name: "Запрещённое изменение" } }
      assert_response expected_status

      delete product_url(@product, format: :json)
      assert_response expected_status

      post categories_url(format: :json),
           params: { category: { name: "Запрещённая категория" } }
      assert_response expected_status

      patch category_url(categories(:one), format: :json),
            params: { category: { name: "Запрещённое изменение" } }
      assert_response expected_status

      delete category_url(categories(:one), format: :json)
      assert_response expected_status

      post brands_url(format: :json),
           params: { brand: { name: "Запрещённый бренд" } }
      assert_response expected_status

      patch brand_url(brands(:one), format: :json),
            params: { brand: { name: "Запрещённое изменение" } }
      assert_response expected_status

      delete brand_url(brands(:one), format: :json)
      assert_response expected_status
    end

    records.each_with_index do |record, index|
      assert_equal snapshots[index], record.reload.attributes
    end
  end
end
