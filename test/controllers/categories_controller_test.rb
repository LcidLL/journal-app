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

  test "should not create category with invalid params" do
    assert_no_difference("Category.count") do
      post categories_path, params: { 
        category: { 
          category_name: "",
          description: "Test description"
        }
      }
    end
    assert_response :unprocessable_entity
  end

  test "should get edit" do
    get edit_category_path(@category)
    assert_response :success
    assert_select "h1", "Edit Category"
  end

  test "should update category with valid params" do
    patch category_path(@category), params: {
      category: { category_name: "Updated Category" }
    }
    assert_redirected_to category_path(@category)
    @category.reload
    assert_equal "Updated Category", @category.category_name
  end

  test "should destroy category" do
    assert_difference("Category.count", -1) do
      delete category_path(@category), params: {}, headers: { "Accept" => "text/html" }
    end
    assert_redirected_to categories_path
  end

  test "should not access other users categories" do
    other_user = User.create!(
      email: "other@example.com",
      first_name: "Other",
      last_name: "User",
      password: "password123"
    )
    other_category = Category.create!(
      category_name: "Other Category",
      user: other_user
    )
    
    get category_path(other_category)
    assert_response :redirect
    assert_redirected_to categories_path
  end
end