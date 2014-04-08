class Question < ActiveRecord::Base
  include Slugable

  attr_accessible :question_text, :category_id, :user_id

  has_many :answers
  belongs_to :category
  belongs_to :user
  has_many :quiz_settings
  has_many :quizzes, through: :quiz_settings

  validates :question_text, presence: true
  validates :category_id, presence: true

  slugable_column :question_text
end