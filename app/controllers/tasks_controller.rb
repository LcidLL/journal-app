class TasksController < ApplicationController
  before_action :authenticate_user!
  before_action :set_category, except: [:index]
  before_action :set_task, only: [:show, :edit, :update, :destroy]
  before_action :check_owner
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

  def index
    @tasks = current_user.tasks.includes(:category).ordered_by_due_date
    @overdue_tasks, @due_today_tasks, @completed_tasks, @priority_tasks, @in_progress_tasks, @due_this_week_tasks = @tasks.overdue, @tasks.due_today, @tasks.completed, @tasks.priority, @tasks.in_progress, @tasks.due_this_week
    @today_priority_tasks, @high_priority_today = @tasks.today_priorities, @tasks.high_priority_today
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

  def show
  end

  def edit
  end

  def record_not_found
    redirect_to categories_path, alert: 'Task not found.'
  end


  private

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