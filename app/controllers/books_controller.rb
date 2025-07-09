class BooksController < ApplicationController
  before_action :authenticate_user!
  before_action :set_book, only: [:show, :edit, :update, :destroy]
  before_action :check_owner, only: [:show, :edit, :update, :destroy]
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

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
      redirect_to @book, notice: "'#{@book.title}' was successfully added to your library!"
    else
      flash.now[:alert] = "There were errors creating your book. Please check the fields below."
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @book.update(book_params)
      redirect_to @book, notice: "'#{@book.title}' was successfully updated!"
    else
      flash.now[:alert] = "There were errors updating your book. Please check the fields below."
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    book_title = @book.title
    @book.destroy
    redirect_to books_path, notice: "'#{book_title}' was successfully removed from your library."
  end

  private

  def set_book
    @book = Book.find(params[:id])
  end

  def check_owner
    redirect_to books_path, alert: 'Access denied. You can only access your own books.' unless @book.user == current_user
  end

  def book_params
    params.require(:book).permit(:title, :author, :publish_date, :summary)
  end
end