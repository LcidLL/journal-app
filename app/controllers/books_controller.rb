class BooksController < ApplicationController
  before_action :authenticate_user!
  before_action :set_book, only: [:show, :edit, :update, :destroy]
  before_action :check_owner, only: [:show, :edit, :update, :destroy]

  def index
    @books = current_user.books.recent.includes(:tasks)
    @books = @books.where("title ILIKE ?", "%#{params[:search]}%") if params[:search].present?
  end

  def show
    @tasks = @book.tasks.order(:created_at)
    @new_task = @book.tasks.build
  end

  def new
    @book = current_user.books.build
  end

  def create
    @book = current_user.books.build(book_params)
    
    if @book.save
      redirect_to @book, notice: 'Book was successfully created.'
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @book.update(book_params)
      redirect_to @book, notice: 'Book was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @book.destroy
    redirect_to books_path, notice: 'Book was successfully deleted.'
  end

  private

  def set_book
    @book = Book.find(params[:id])
  end

  def check_owner
    redirect_to books_path, alert: 'Access denied.' unless @book.user == current_user
  end

  def book_params
    params.require(:book).permit(:title, :author, :publish_date, :summary)
  end
end