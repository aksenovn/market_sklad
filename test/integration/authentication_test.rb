require "test_helper"

class AuthenticationTest < ActionDispatch::IntegrationTest
  setup do
    Rails.cache.clear
  end

  test "registration page opens" do
    get new_registration_url

    assert_response :success
    assert_select "h1", text: "Регистрация"
  end

  test "registration creates customer and signs them in" do
    assert_difference("User.count", 1) do
      post registration_url, params: {
        user: registration_attributes.merge(role: "employee")
      }
    end

    user = User.find_by!(email_address: "new@example.com")

    assert_equal "customer", user.role
    assert_equal "Новый покупатель", user.name
    assert user.authenticate("TestPassword123")
    assert_redirected_to root_url

    follow_redirect!

    assert_select ".account-name", text: user.name
    assert_select "button", text: "Выйти"
  end

  test "registration rejects duplicate email" do
    attributes = registration_attributes.merge(
      email_address: users(:customer).email_address.upcase
    )

    assert_no_difference("User.count") do
      post registration_url, params: { user: attributes }
    end

    assert_response :unprocessable_content
    assert_select ".flash-alert", text: /Эта почта уже зарегистрирована/
  end

  test "registration rejects short password" do
    attributes = registration_attributes.merge(
      password: "Short1",
      password_confirmation: "Short1"
    )

    assert_no_difference("User.count") do
      post registration_url, params: { user: attributes }
    end

    assert_response :unprocessable_content
  end

  test "registration rejects mismatched password confirmation" do
    attributes = registration_attributes.merge(
      password_confirmation: "DifferentPassword123"
    )

    assert_no_difference("User.count") do
      post registration_url, params: { user: attributes }
    end

    assert_response :unprocessable_content
  end

  test "login page opens" do
    get new_session_url

    assert_response :success
    assert_select "h1", text: "Вход в аккаунт"
  end

  test "correct credentials sign user in" do
    post session_url, params: {
      session: {
        email_address: " CUSTOMER@EXAMPLE.COM ",
        password: "TestPassword123"
      }
    }

    assert_redirected_to root_url

    follow_redirect!

    assert_select ".account-name", text: users(:customer).name
  end

  test "incorrect password does not sign user in" do
    post session_url, params: {
      session: {
        email_address: users(:customer).email_address,
        password: "WrongPassword123"
      }
    }

    assert_response :unprocessable_content
    assert_select ".flash-alert", text: "Неверная почта или пароль."
    assert_select ".account-name", count: 0
  end

  test "logout ends the session" do
    post session_url, params: {
      session: {
        email_address: users(:customer).email_address,
        password: "TestPassword123"
      }
    }

    delete session_url

    assert_redirected_to root_url

    follow_redirect!

    assert_select ".account-name", count: 0
    assert_select "a", text: "Войти"
  end

  private

  def registration_attributes
    {
      name: " Новый покупатель ",
      email_address: " NEW@EXAMPLE.COM ",
      password: "TestPassword123",
      password_confirmation: "TestPassword123"
    }
  end
end
