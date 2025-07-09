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

  test "should not create task with invalid params" do
    assert_no_difference("Task.count") do
      post category_tasks_path(@category), params: {
        task: {
          task_name: "",
          status: "priority"
        }
      }
    end
    assert_response :unprocessable_entity
  end

  test "should get edit" do
    get edit_category_task_path(@category, @task)
    assert_response :success
    assert_select "h1", "Edit Task"
  end

  test "should update task with valid params" do
    patch category_task_path(@category, @task), params: {
      task: { task_name: "Updated Task" }
    }
    assert_redirected_to category_path(@category)
    @task.reload
    assert_equal "Updated Task", @task.task_name
  end

  test "should destroy task" do
    assert_difference("Task.count", -1) do
      delete category_task_path(@category, @task), params: {}, headers: { "Accept" => "text/html" }
    end
    assert_redirected_to category_path(@category)
  end

  test "should not access other users tasks" do
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
    other_task = Task.create!(
      task_name: "Other Task",
      category: other_category,
      status: "priority"
    )

    get category_task_path(other_category, other_task)
    assert_response :redirect
    assert_redirected_to categories_path
  end

  test "should redirect when not authenticated" do
    sign_out @user
    get tasks_path
    assert_response :redirect
    assert_redirected_to new_user_session_path
  end
end