class Question < ActiveRecord::Base
  has_many :answers
  belongs_to :category
  belongs_to :user
  validates :question_text, presence: true
  validates :category_id, presence: true
end