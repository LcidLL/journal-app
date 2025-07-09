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

  test "should not save task with invalid status" do
    task = Task.new(
      task_name: "Test Task",
      category: @category,
      status: "invalid_status"
    )
    assert_not task.save
  end

  test "should not save task with task_name longer than 255 characters" do
    task = Task.new(
      task_name: "a" * 256,
      category: @category,
      status: "priority"
    )
    assert_not task.save
  end

  test "should not save task with description longer than 2000 characters" do
    task = Task.new(
      task_name: "Test Task",
      description: "a" * 2001,
      category: @category,
      status: "priority"
    )
    assert_not task.save
  end

  test "should belong to category" do
    task = tasks(:one)
    assert_respond_to task, :category
  end

test "should detect overdue tasks" do
  task = Task.create!(
    task_name: "Test Task",
    category: @category,
    status: "priority",
    due_date: 1.week.from_now
  )
  
  task.update_column(:due_date, 1.day.ago)
  assert task.overdue?
end

  test "should detect due today tasks" do
    task = Task.new(
      task_name: "Test Task",
      category: @category,
      status: "priority",
      due_date: Date.current
    )
    assert task.due_today?
  end

  test "should return correct status color" do
    task = Task.new(status: "completed")
    assert_equal "success", task.status_color
    
    task.status = "priority"
    assert_equal "info", task.status_color
    
    task.status = "in_progress"
    assert_equal "warning", task.status_color
  end

  test "should mark task as completed" do
    task = Task.create!(
      task_name: "Test Task",
      category: @category,
      status: "priority"
    )
    task.mark_as_completed!
    assert_equal "completed", task.status
  end

  test "should mark task as in progress" do
    task = Task.create!(
      task_name: "Test Task",
      category: @category,
      status: "priority"
    )
    task.mark_as_in_progress!
    assert_equal "in_progress", task.status
  end

  test "should mark task as priority" do
    task = Task.create!(
      task_name: "Test Task",
      category: @category,
      status: "completed"
    )
    task.mark_as_priority!
    assert_equal "priority", task.status
  end
end