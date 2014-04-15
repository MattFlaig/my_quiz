class Quiz < ActiveRecord::Base
  # load module from /lib into quiz class
  include Slugable

  # via gem 'protected_attributes' attr_accessible is still available in rails 4
  attr_accessible :quiz_name, :description, :category_id, :user_id, :question_ids 

  has_many :quiz_settings
  has_many :questions, through: :quiz_settings
  has_many :reviews

  belongs_to :category
  belongs_to :user

  validates :quiz_name, :description, presence: true

  #call custom validation method below
  validate :questions_present?

  #specify column from which slug is built
  slugable_column :quiz_name

  private

  #custom validation method
  def questions_present?
    if question_ids.empty?
      errors.add(:questions, "can't be blank")
    end
  end
end

