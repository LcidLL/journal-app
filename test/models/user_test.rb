require "test_helper"

class UserTest < ActiveSupport::TestCase
  test "should not save user without email" do
    user = User.new(first_name: "Test", last_name: "Testing")
    assert_not user.save
  end

  test "should not save user without first name" do
    user = User.new(email: "test@example.com", last_name: "Testing")
    assert_not user.save
  end

  test "should not save user without last name" do
    user = User.new(email: "test@example.com", first_name: "Test")
    assert_not user.save
  end

  test "should save user with valid params" do
    user = User.new(
      email: "test@example.com",
      first_name: "Test",
      last_name: "Testing",
      password: "password123"
    )
    assert user.save
  end
end