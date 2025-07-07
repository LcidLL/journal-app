class TasksController < ApplicationController
  before_action :authenticate_user!
  before_action :set_book, except: [:index]
  before_action :set_task, only: [:show, :edit, :update, :destroy]
  before_action :check_owner

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
      redirect_to @book, notice: 'Reading task was successfully created.'
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @task.update(task_params)
      redirect_to @book, notice: 'Reading task was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @task.destroy
    redirect_to @book, notice: 'Reading task was successfully deleted.'
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
      redirect_to books_path, alert: 'Access denied.' unless @book.user == current_user
    elsif @task&.book
      redirect_to books_path, alert: 'Access denied.' unless @task.book.user == current_user
    end
  end

  def task_params
    params.require(:task).permit(:reading_status, :chapter_summary, :target_date)
  end
end