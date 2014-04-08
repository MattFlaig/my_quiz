class Answer < ActiveRecord::Base
  include Slugable

  attr_accessible :answer_text, :question_id, :correct 
  belongs_to :question

  validates :answer_text, presence:true
  slugable_column :answer_text
end