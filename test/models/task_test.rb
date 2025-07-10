require "test_helper"

class TaskTest < ActiveSupport::TestCase
  def setup
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
  end

  test "should not save task without task_name" do
    task = Task.new(category: @category, status: "priority")
    assert_not task.save
  end

  test "should not save task without category" do
    task = Task.new(task_name: "Test Task", status: "priority")
    assert_not task.save
  end

  test "should save task with valid params" do
    task = Task.new(
      task_name: "Test Task",
      category: @category,
      status: "priority"
    )
    assert task.save
  end
end