class Task < ApplicationRecord
  belongs_to :category

  validates :task_name, presence: { message: "cannot be blank" }, 
    length: { minimum: 1, maximum: 255 }
  validates :description, length: { maximum: 2000 }, 
    allow_blank: true
  validates :due_date, presence: false
  validates :category_id, presence: true

  STATUSES = %w[priority in_progress completed overdue].freeze
  validates :status, inclusion: { 
    in: STATUSES, 
    message: "must be one of: #{STATUSES.join(', ')}" 
  }
  
  validate :due_date_cannot_be_in_past, if: :due_date?, on: :create
  validate :due_date_reasonable_future, if: :due_date?

  scope :completed, -> { where(status: 'completed') }
  scope :priority, -> { where(status: 'priority') }
  scope :in_progress, -> { where(status: 'in_progress') }
  scope :overdue, -> { where('due_date < ? AND status != ?', Date.current, 'completed') }
  scope :due_today, -> { where(due_date: Date.current) }
  scope :due_this_week, -> { where(due_date: Date.current.beginning_of_week..Date.current.end_of_week) }
  scope :ordered_by_due_date, -> { order(:due_date) }
  scope :ordered_by_priority, -> { order(:due_date, :created_at) }
  
  # (User Story #8)
  scope :today_priorities, -> { where(status: 'priority').where(due_date: Date.current) }
  scope :high_priority_today, -> { where(status: 'priority').where('due_date <= ?', Date.current) }

  def overdue?
    due_date.present? && due_date < Date.current && status != 'completed'
  end

  def due_today?
    due_date == Date.current
  end

  def priority_task?
    status == 'priority'
  end

  def status_color
    case status
    when 'completed'
      'success'
    when 'in_progress'
      'warning'
    when 'priority'
      'info'
    when 'overdue'
      'danger'
    else
      'secondary'
    end
  end

  def days_until_due
    return nil unless due_date
    (due_date - Date.current).to_i
  end

  def mark_as_completed!
    update!(status: 'completed')
  end

  def mark_as_in_progress!
    update!(status: 'in_progress')
  end

  def mark_as_priority!
    update!(status: 'priority')
  end

  private

  def due_date_cannot_be_in_past
    if due_date.present? && due_date < Date.current
      errors.add(:due_date, "cannot be in the past")
    end
  end

  def due_date_reasonable_future
    if due_date.present? && due_date > 1.year.from_now
      errors.add(:due_date, "cannot be more than 1 year in the future")
    end
  end
end