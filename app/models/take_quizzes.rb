class TakeQuizzes < ActiveRecord::Base
  attr_accessible :quiz_id, :user_id, :score

  belongs_to :user 
  belongs_to :quiz
end