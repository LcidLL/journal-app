class Category < ApplicationRecord
  belongs_to :user
  has_many :tasks, dependent: :destroy

  validates :category_name, presence: { message: "cannot be blank" }, 
    length: { minimum: 1, maximum: 255 }
  validates :description, length: { maximum: 2000 }, 
    allow_blank: true
  validates :user_id, presence: true

  scope :recent, -> { order(created_at: :desc) }
  scope :by_name, ->(name) { where('category_name ILIKE ?', "%#{name}%") }

  def task_progress
    total_tasks = tasks.count
    completed_tasks = tasks.where(status: 'completed').count
    return 0 if total_tasks == 0
    (completed_tasks.to_f / total_tasks * 100).round(2)
  end
end