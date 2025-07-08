class Book < ApplicationRecord
  belongs_to :user
  has_many :tasks, dependent: :destroy

  validates :title, presence: true
  validates :author, presence: true
  validates :user_id, presence: true

  scope :recent, -> { order(created_at: :desc) }
  scope :by_author, ->(author) { where(author: author) }

  def reading_progress
    total_tasks = tasks.count
    completed_tasks = tasks.where(reading_status: 'completed').count
    return 0 if total_tasks == 0
    (completed_tasks.to_f / total_tasks * 100).round(2)
  end
end