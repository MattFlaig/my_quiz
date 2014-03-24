class Quiz < ActiveRecord::Base
  has_many :quiz_settings
  has_many :questions, through: :quiz_settings

  belongs_to :category
  belongs_to :user

  validates :quiz_name, :description, :category_id, presence: true
end