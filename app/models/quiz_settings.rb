class QuizSetting < ActiveRecord::Base
  belongs_to :question
  belongs_to :quiz
end