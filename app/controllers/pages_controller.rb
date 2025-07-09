class PagesController < ApplicationController
  before_action :authenticate_user!
  
  def index
    @recent_categories = current_user.categories.recent.limit(5)
    @overdue_tasks = current_user.tasks.overdue.limit(5)
    @total_categories = current_user.categories.count
    @completed_tasks = current_user.tasks.completed.count
    @priority_tasks = current_user.tasks.priority.count
    @in_progress_tasks = current_user.tasks.in_progress.count
    @due_today_tasks = current_user.tasks.due_today.limit(5)
    @total_tasks = current_user.tasks.count
    @today_priority_tasks = current_user.tasks.today_priorities.limit(10)
    @high_priority_today = current_user.tasks.high_priority_today.limit(10)
  end
end