class PagesController < ApplicationController
  before_action :authenticate_user!

  def index
    @recent_books = current_user.books.recent.limit(5)
    @overdue_tasks = current_user.tasks.overdue.limit(5)
    @total_books = current_user.books.count
    @completed_tasks = current_user.tasks.completed.count
    @in_progress_tasks = current_user.tasks.in_progress.count
  end
end