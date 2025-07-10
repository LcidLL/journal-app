require "test_helper"

class PagesControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @user = User.create!(
      email: "test@example.com",
      first_name: "Test",
      last_name: "User",
      password: "password123"
    )
    sign_in @user
  end

  test "should get index when signed in" do
    get root_path
    assert_response :success
    assert_select "h1", "My Dashboard"
  end

  test "should redirect to sign in when not authenticated" do
    sign_out @user
    get root_path
    assert_response :redirect
    assert_redirected_to new_user_session_path
  end
end