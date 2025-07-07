class Task < ApplicationRecord
  belongs_to :book

  validates :reading_status, presence: true
  validates :book_id, presence: true

  READING_STATUSES = %w[not_started reading completed on_hold].freeze

  validates :reading_status, inclusion: { in: READING_STATUSES }

  scope :completed, -> { where(reading_status: 'completed') }
  scope :in_progress, -> { where(reading_status: 'reading') }
  scope :overdue, -> { where('target_date < ? AND reading_status != ?', Date.current, 'completed') }

  def overdue?
    target_date.present? && target_date < Date.current && reading_status != 'completed'
  end

  def status_color
    case reading_status
    when 'completed'
      'success'
    when 'reading'
      'info'
    when 'on_hold'
      'warning'
    else 
      'secondary'
    end
  end
end
