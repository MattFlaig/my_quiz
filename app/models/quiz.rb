class Quiz < ActiveRecord::Base
  require 'pry'
  attr_accessible :quiz_name, :description, :category_id, :question_ids, :user_id 

  has_many :quiz_settings
  has_many :questions, through: :quiz_settings

  belongs_to :category
  belongs_to :user

  #validates :question_ids, presence: true
  validates :quiz_name, :description, presence: true

end

