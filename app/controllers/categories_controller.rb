class CategoriesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_category, only: [:show, :edit, :update, :destroy]
  before_action :check_owner, only: [:show, :edit, :update, :destroy]
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found
  rescue_from ActiveRecord::InvalidForeignKey, with: :render_internal_error

  def index
    @categories = current_user.categories.recent.includes(:tasks)
    @total_tasks = current_user.tasks.count
    @completed_tasks = current_user.tasks.completed.count
    @priority_tasks = current_user.tasks.priority.count
    @overdue_tasks = current_user.tasks.overdue.count
  end

  def show
    @tasks = @category.tasks.ordered_by_due_date
    @new_task = @category.tasks.build
    @completed_tasks = @tasks.completed
    @priority_tasks = @tasks.priority
    @overdue_tasks = @tasks.overdue
  end

  def new
    @category = current_user.categories.build
  end

  def create
    @category = current_user.categories.build(category_params)
    
    if @category.save
      redirect_to @category, notice: "'#{@category.category_name}' category was successfully created!"
    else
      flash.now[:alert] = "There were errors creating your category. Please check the fields below."
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @category.update(category_params)
      redirect_to @category, notice: "'#{@category.category_name}' category was successfully updated!"
    else
      flash.now[:alert] = "There were errors updating your category. Please check the fields below."
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    category_name = @category.category_name
    @category.destroy
    redirect_to categories_path, notice: "'#{category_name}' category was successfully deleted."
  end

  private

  def render_not_found
    redirect_to categories_path, alert: 'Category not found.'
  end

  def render_internal_error
    redirect_to categories_path, alert: 'An error occurred. Please try again.'
  end

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