class CategoriesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_category, only: [:show, :edit, :update, :destroy]
  before_action :check_owner, only: [:show, :edit, :update, :destroy]
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

  # INDEX
  def index
    @categories = current_user.categories.recent.includes(:tasks)
    @total_tasks, @completed_tasks, @priority_tasks, @overdue_tasks = current_user.tasks.count, current_user.tasks.completed.count, current_user.tasks.priority.count, current_user.tasks.overdue.count
  end

  # SHOW
  def show
    @tasks = @category.tasks.ordered_by_due_date
    @new_task = @category.tasks.build
    @completed_tasks, @priority_tasks, @overdue_tasks = @tasks.completed, @tasks.priority, @tasks.overdue
  end

  # NEW
  def new
    @category = current_user.categories.build
  end

  # CREATE
  def create
    @category = current_user.categories.build(category_params)
    if @category.save
      redirect_to @category, notice: "'#{@category.category_name}' category was successfully created!"
    else
      flash.now[:alert] = "There were errors creating your category. Please check the fields below."
      render :new, status: :unprocessable_entity
    end
  end

  # UPDATE
  def update
    if @category.update(category_params)
      redirect_to @category, notice: "'#{@category.category_name}' category was successfully updated!"
    else
      flash.now[:alert] = "There were errors updating your category. Please check the fields below."
      render :edit, status: :unprocessable_entity
    end
  end

  # DESTROY
  def destroy
    category_name = @category.category_name
    @category.destroy
    redirect_to categories_path, notice: "'#{category_name}' category was successfully deleted."
  end

  # EDIT
  def edit
  end

  # RESCUER
  def record_not_found
    redirect_to categories_path, alert: 'Category not found.'
  end


  private

  def set_category
    @category = Category.find(params[:id])
  end

  def check_owner
    redirect_to categories_path, alert: 'Access denied. You can only access your own categories.' unless @category.user == current_user
  end

  def category_params
    params.require(:category).permit(:category_name, :description)
  end
end