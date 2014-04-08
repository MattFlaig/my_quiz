class Quiz < ActiveRecord::Base
  include Slugable

  attr_accessible :quiz_name, :description, :category_id, :user_id, :question_ids 

  has_many :quiz_settings
  has_many :questions, through: :quiz_settings
  has_many :reviews

  belongs_to :category
  belongs_to :user

  validates :quiz_name, :description, presence: true
  validate :questions_present?

  slugable_column :quiz_name

  private

  def questions_present?
    if question_ids.empty?
      errors.add(:questions, "can't be blank")
    end
  end
end

