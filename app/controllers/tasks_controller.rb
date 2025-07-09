class TasksController < ApplicationController
  before_action :authenticate_user!
  before_action :set_book, except: [:index]
  before_action :set_task, only: [:show, :edit, :update, :destroy]
  before_action :check_owner
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

  def index
    @tasks = current_user.tasks.includes(:book).order(:target_date)
    @overdue_tasks = @tasks.overdue
    @completed_tasks = @tasks.completed
    @in_progress_tasks = @tasks.in_progress
  end

  def show
  end

  def new
    @task = @book.tasks.build
  end

  def create
    @task = @book.tasks.build(task_params)
    
    if @task.save
      redirect_to @book, notice: "Reading task for '#{@book.title}' was successfully created!"
    else
      flash.now[:alert] = "There were errors creating your reading task. Please check the fields below."
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @task.update(task_params)
      redirect_to @book, notice: "Reading task for '#{@book.title}' was successfully updated!"
    else
      flash.now[:alert] = "There were errors updating your reading task. Please check the fields below."
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    book_title = @book.title
    @task.destroy
    redirect_to @book, notice: "Reading task for '#{book_title}' was successfully deleted."
  end

  private

  def set_book
    @book = Book.find(params[:book_id]) if params[:book_id]
  end

  def set_task
    @task = @book ? @book.tasks.find(params[:id]) : Task.find(params[:id])
  end

  def check_owner
    if @book
      redirect_to books_path, alert: 'Access denied. You can only access your own books.' unless @book.user == current_user
    elsif @task&.book
      redirect_to books_path, alert: 'Access denied. You can only access your own reading tasks.' unless @task.book.user == current_user
    end
  end

  def task_params
    params.require(:task).permit(:reading_status, :chapter_summary, :target_date)
  end
end