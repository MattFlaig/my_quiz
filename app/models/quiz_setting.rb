class QuizSetting < ActiveRecord::Base
  attr_accessible :quiz_id, :question_id
  belongs_to :question
  belongs_to :quiz
end