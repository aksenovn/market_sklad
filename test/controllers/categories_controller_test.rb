require "test_helper"

class CategoriesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @category = categories(:one)
  end

  test "should get index" do
    get categories_url
    assert_response :success
  end

  test "should get new" do
    get new_category_url
    assert_response :success
  end

  test "should create category" do
  assert_difference("Category.count", 1) do
    post categories_url, params: {
      category: {
        name: "Книги и канцелярия",
        description: "Книги и принадлежности для учёбы"
      }
    }
  end

  assert_redirected_to category_url(Category.last)
  end

  test "should show category" do
    get category_url(@category)
    assert_response :success
  end

  test "should get edit" do
    get edit_category_url(@category)
    assert_response :success
  end

  test "should update category" do
    patch category_url(@category), params: { category: { description: @category.description, name: @category.name } }
    assert_redirected_to category_url(@category)
  end

    test "should destroy unused category" do
    category = Category.create!(name: "Временная категория")

    assert_difference("Category.count", -1) do
      delete category_url(category)
    end

    assert_redirected_to categories_url
  end

  test "should not destroy category with products" do
    assert_no_difference("Category.count") do
      delete category_url(@category)
    end

    assert_redirected_to category_url(@category)
    assert_equal "Нельзя удалить категорию, пока с ней связаны товары.",
                 flash[:alert]
    assert Product.exists?(products(:one).id)
  end
end
