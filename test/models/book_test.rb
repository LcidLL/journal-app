require "test_helper"

class BookTest < ActiveSupport::TestCase
  test "should not save a book without a title" do
    book = Book.new(title: "test title")
    assert_not book.save
  end

  test "should not save a book without an author" do
    book = Book.new(author: "test author")
    assert_not book.save
  end
  
  test "should save a book with valid params" do
    book = Book.new(title: "test title", author: "test author")
    assert book.save
  end
end
