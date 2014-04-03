class Quiz < ActiveRecord::Base
  require 'pry'
  attr_accessible :quiz_name, :description, :category_id, :user_id, :question_ids 

  has_many :quiz_settings
  has_many :questions, through: :quiz_settings

  belongs_to :category
  belongs_to :user

  #validates :questions, presence: true, associated: true
  validates :quiz_name, :description, presence: true
  validate :questions_present?

  private

  def questions_present?
    if question_ids.empty?
      errors.add(:questions, "can't be blank")
    end
  end
end

