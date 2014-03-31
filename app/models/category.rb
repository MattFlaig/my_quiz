class Category < ActiveRecord::Base
  attr_accessible :category_name
  has_many :questions
  has_many :quizzes
end