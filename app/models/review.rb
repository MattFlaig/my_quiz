class Review < ActiveRecord::Base
  attr_accessible :content, :rating, :user_id, :quiz_id 

  belongs_to :user
  belongs_to :quiz

  validates_presence_of :content, :rating
end