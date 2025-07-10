require "test_helper"

class CategoryTest < ActiveSupport::TestCase
  test "should not save category without category_name" do
    category = Category.new(user: users(:one))
    assert_not category.save
  end

  test "should not save category without user" do
    category = Category.new(category_name: "Test Category")
    assert_not category.save
  end

  test "should save category with valid params" do
    category = Category.new(
      category_name: "Test Category",
      user: users(:one)
    )
    assert category.save
  end
end