require "test_helper"

class BookTest < ActiveSupport::TestCase
  test "should not save a book without a title" do
    book = Book.new
    book.title = "test title"
    book.author = "test author"

    assert_not book.save
  end
end
