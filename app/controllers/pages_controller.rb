class PagesController < ApplicationController
  before_action :authenticate_user!
  
  def index
    @recent_categories, @overdue_tasks, @due_today_tasks, @today_priority_tasks, @high_priority_today = current_user.categories.recent.limit(5), current_user.tasks.overdue.limit(5), current_user.tasks.due_today.limit(5), current_user.tasks.today_priorities.limit(10), current_user.tasks.high_priority_today.limit(10)
    @total_categories, @completed_tasks, @priority_tasks, @in_progress_tasks, @total_tasks = current_user.categories.count, current_user.tasks.completed.count, current_user.tasks.priority.count, current_user.tasks.in_progress.count, current_user.tasks.count
  end
end