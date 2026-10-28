require "application_system_test_case"

class NavigationTest < ApplicationSystemTestCase
  test "visitor opens brands from the home page" do
    visit root_url

    assert_selector "h1", text: "От выбора товара"

    within "nav" do
      click_on "Бренды"
    end

    assert_selector "h1", text: "Бренды товаров"
    assert_link "Добавить бренд"
  end
end
