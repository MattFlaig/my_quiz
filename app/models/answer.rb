class Answer < ActiveRecord::Base
  attr_accessible :answer_text, :question_id, :correct 
  belongs_to :question
  validates :answer_text, presence:true
end