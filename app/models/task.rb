class Task < ApplicationRecord
  belongs_to :book

  validates :reading_status, presence: { message: "cannot be blank" }
  validates :book_id, presence: true
  READING_STATUSES = %w[not_started reading completed on_hold].freeze
  validates :reading_status, inclusion: { 
    in: READING_STATUSES, 
    message: "must be selected." 
  }
  validates :chapter_summary, length: { 
    maximum: 2000, 
    message: "cannot exceed 2000 characters" 
  }, allow_blank: true
  validates :target_date, presence: false
  validate :target_date_cannot_be_in_past, if: :target_date?

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

  private

  def target_date_cannot_be_in_past
    if target_date.present? && target_date < Date.current
      errors.add(:target_date, "cannot be in the past")
    end
  end
end