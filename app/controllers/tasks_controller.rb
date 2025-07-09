class TasksController < ApplicationController
  before_action :authenticate_user!
  before_action :set_category, except: [:index]
  before_action :set_task, only: [:show, :edit, :update, :destroy]
  before_action :check_owner
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found
  rescue_from ActiveRecord::InvalidForeignKey, with: :render_internal_error

  def index
    @tasks = current_user.tasks.includes(:category).ordered_by_due_date
    @overdue_tasks = @tasks.overdue
    @due_today_tasks = @tasks.due_today
    @completed_tasks = @tasks.completed
    @priority_tasks = @tasks.priority
    @in_progress_tasks = @tasks.in_progress
    @due_this_week_tasks = @tasks.due_this_week
    
    # For User Story #8: Today's priorities
    @today_priority_tasks = @tasks.today_priorities
    @high_priority_today = @tasks.high_priority_today
  end

  def show
  end

  def new
    @task = @category.tasks.build
  end

  def create
    @task = @category.tasks.build(task_params)
    
    if @task.save
      redirect_to @category, notice: "Task '#{@task.task_name}' was successfully created!"
    else
      flash.now[:alert] = "There were errors creating your task. Please check the fields below."
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @task.update(task_params)
      redirect_to @category, notice: "Task '#{@task.task_name}' was successfully updated!"
    else
      flash.now[:alert] = "There were errors updating your task. Please check the fields below."
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    task_name = @task.task_name
    @task.destroy
    redirect_to @category, notice: "Task '#{task_name}' was successfully deleted."
  end

  private

  def render_not_found
    redirect_to categories_path, alert: 'Task not found.'
  end

  def render_internal_error
    redirect_to categories_path, alert: 'An error occurred. Please try again.'
  end

  def set_category
    @category = Category.find(params[:category_id]) if params[:category_id]
  end

  def set_task
    @task = @category ? @category.tasks.find(params[:id]) : Task.find(params[:id])
  end

  def check_owner
    if @category
      redirect_to categories_path, alert: 'Access denied. You can only access your own categories.' unless @category.user == current_user
    elsif @task&.category
      redirect_to categories_path, alert: 'Access denied. You can only access your own tasks.' unless @task.category.user == current_user
    end
  end

  def task_params
    params.require(:task).permit(:task_name, :description, :due_date, :status)
  end
end