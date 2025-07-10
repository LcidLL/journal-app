require "test_helper"

class CategoriesControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @user = User.create!(
      email: "test@example.com",
      first_name: "Test",
      last_name: "User",
      password: "password123"
    )
    @category = Category.create!(
      category_name: "Test Category",
      user: @user
    )
    sign_in @user
  end

  test "should get index" do
    get categories_path
    assert_response :success
    assert_select "h1", "My Journal"
  end

  test "should get show" do
    get category_path(@category)
    assert_response :success
    assert_select "h1", @category.category_name
  end

  test "should get new" do
    get new_category_path
    assert_response :success
    assert_select "h1", "Add New Category"
  end

  test "should create category with valid params" do
    assert_difference("Category.count") do
      post categories_path, params: { 
        category: { 
          category_name: "New Category",
          description: "Test description"
        }
      }
    end
    assert_redirected_to category_path(Category.last)
  end
end