require "test_helper"

class UserTest < ActiveSupport::TestCase
  test "should not save user without email" do
    user = User.new(first_name: "John", last_name: "Doe")
    assert_not user.save
  end

  test "should not save user without first name" do
    user = User.new(email: "test@example.com", last_name: "Doe")
    assert_not user.save
  end

  test "should not save user without last name" do
    user = User.new(email: "test@example.com", first_name: "John")
    assert_not user.save
  end

  test "should save user with valid params" do
    user = User.new(
      email: "test@example.com",
      first_name: "John",
      last_name: "Doe",
      password: "password123"
    )
    assert user.save
  end

  test "should return full name" do
    user = User.new(first_name: "John", last_name: "Doe")
    assert_equal "John Doe", user.full_name
  end

  test "should have many categories" do
    user = users(:one)
    assert_respond_to user, :categories
  end

  test "should have many tasks through categories" do
    user = users(:one)
    assert_respond_to user, :tasks
  end
end
