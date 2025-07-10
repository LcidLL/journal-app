require "test_helper"

class TasksControllerTest < ActionDispatch::IntegrationTest
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
    @task = Task.create!(
      task_name: "Test Task",
      category: @category,
      status: "priority"
    )
    sign_in @user
  end

  test "should get index" do
    get tasks_path
    assert_response :success
    assert_select "h1", "All Tasks"
  end

  test "should get show" do
    get category_task_path(@category, @task)
    assert_response :success
    assert_select "h1", "Task Details"
  end

  test "should get new" do
    get new_category_task_path(@category)
    assert_response :success
    assert_select "h1", "New Task"
  end

  test "should create task with valid params" do
    assert_difference("Task.count") do
      post category_tasks_path(@category), params: {
        task: {
          task_name: "New Task",
          description: "Test description",
          status: "priority",
          due_date: 1.week.from_now
        }
      }
    end
    assert_redirected_to category_path(@category)
  end
end