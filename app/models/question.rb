class Question < ActiveRecord::Base
  has_many :answers
  belongs_to :category
  belongs_to :user

  validates :question_text, presence: true
  validates :category_id, presence: true

  has_many :quiz_settings
  has_many :quizzes, through: :quiz_settings
end