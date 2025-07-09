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

  test "should not save category with category_name longer than 255 characters" do
    category = Category.new(
      category_name: "a" * 256,
      user: users(:one)
    )
    assert_not category.save
  end

  test "should not save category with description longer than 2000 characters" do
    category = Category.new(
      category_name: "Test Category",
      description: "a" * 2001,
      user: users(:one)
    )
    assert_not category.save
  end

  test "should belong to user" do
    category = categories(:one)
    assert_respond_to category, :user
  end

  test "should have many tasks" do
    category = categories(:one)
    assert_respond_to category, :tasks
  end

  test "should calculate task progress" do
    category = categories(:one)
    assert_respond_to category, :task_progress
    assert_kind_of Numeric, category.task_progress
  end
end