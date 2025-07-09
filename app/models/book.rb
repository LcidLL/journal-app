class Book < ApplicationRecord
  belongs_to :user
  has_many :tasks, dependent: :destroy

  validates :title, presence: { message: "cannot be blank" }, 
    length: { minimum: 1, maximum: 255 }
  validates :author, presence: { message: "cannot be blank" }, 
    length: { minimum: 1, maximum: 255 }
  validates :user_id, presence: true
  validates :summary, length: { maximum: 2000 }, 
    allow_blank: true
  validates :publish_date, presence: false
  validate :publish_date_cannot_be_in_future, if: :publish_date?

  scope :recent, -> { order(created_at: :desc) }
  scope :by_author, ->(author) { where(author: author) }

  def reading_progress
    total_tasks = tasks.count
    completed_tasks = tasks.where(reading_status: 'completed').count
    return 0 if total_tasks == 0
    (completed_tasks.to_f / total_tasks * 100).round(2)
  end

  private

  def publish_date_cannot_be_in_future
    if publish_date.present? && publish_date > Date.current
      errors.add(:publish_date, "cannot be in the future")
    end
  end
end