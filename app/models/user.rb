class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :categories, dependent: :destroy
  has_many :tasks, through: :categories

  validates :email, presence: true, uniqueness: true
  validates :first_name, presence: true, length: { minimum: 1, maximum: 100 }
  validates :last_name, presence: true, length: { minimum: 1, maximum: 100 }
  
  def full_name
    "#{first_name} #{last_name}".strip
  end
end
