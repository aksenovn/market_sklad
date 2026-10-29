require "test_helper"

class ProductFiltersTest < ActionDispatch::IntegrationTest
  setup do
    @phone = products(:one)
    @vacuum = products(:two)

    # Fixtures загружаются без callbacks, поэтому заполняем поисковое поле.
    @phone.save!
    @vacuum.save!
  end

  test "search finds Russian names regardless of case" do
    get products_url, params: { q: "СМАРТФОН" }

    assert_response :success
    assert_select ".feature-card h2", text: @phone.name
    assert_select ".feature-card h2", text: @vacuum.name, count: 0
  end

  test "search finds an article regardless of case" do
    get products_url, params: { q: "sam-001" }

    assert_response :success
    assert_select ".feature-card h2", text: @phone.name
    assert_select ".feature-card", count: 1
  end

  test "category and brand filters work together" do
    get products_url, params: {
      category_id: @phone.category_id,
      brand_id: @phone.brand_id
    }

    assert_response :success
    assert_select ".feature-card h2", text: @phone.name
    assert_select ".feature-card", count: 1
  end

  test "incompatible filters return no products" do
    get products_url, params: {
      category_id: @phone.category_id,
      brand_id: @vacuum.brand_id
    }

    assert_select ".feature-card", count: 0
    assert_select "h2", text: "Товары не найдены"
  end

  test "status filters distinguish active and archived products" do
    @vacuum.update!(active: false)

    get products_url, params: { status: "active" }

    assert_select ".feature-card h2", text: @phone.name
    assert_select ".feature-card h2", text: @vacuum.name, count: 0

    get products_url, params: { status: "archived" }

    assert_select ".feature-card h2", text: @vacuum.name
    assert_select ".feature-card h2", text: @phone.name, count: 0
  end

  test "products can be sorted by price in both directions" do
    get products_url, params: { sort: "price_asc" }

    names = css_select(".feature-card h2").map { |node| node.text.strip }
    assert_equal [ @vacuum.name, @phone.name ], names

    get products_url, params: { sort: "price_desc" }

    names = css_select(".feature-card h2").map { |node| node.text.strip }
    assert_equal [ @phone.name, @vacuum.name ], names
  end

  test "unknown search shows an empty result message" do
    get products_url, params: { q: "Несуществующий товар" }

    assert_select ".feature-card", count: 0
    assert_select "h2", text: "Товары не найдены"
  end
end
