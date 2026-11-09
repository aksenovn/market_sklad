require "test_helper"

class SupplierAccessTest < ActionDispatch::IntegrationTest
  test "guest cannot view suppliers" do
    get suppliers_url
    assert_redirected_to new_session_url

    get supplier_url(suppliers(:one), format: :json)
    assert_response :unauthorized
  end

  test "customer cannot view or create suppliers" do
    Rails.cache.clear

    post session_url, params: {
      session: {
        email_address: users(:customer).email_address,
        password: "TestPassword123"
      }
    }
    assert_redirected_to root_url

    get suppliers_url
    assert_redirected_to root_url

    get supplier_url(suppliers(:one), format: :json)
    assert_response :forbidden

    assert_no_difference("Supplier.count") do
      post suppliers_url(format: :json),
           params: { supplier: { name: "Запрещённый поставщик" } }
      assert_response :forbidden
    end
  end
end
