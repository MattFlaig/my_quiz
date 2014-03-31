class User < ActiveRecord::Base
  attr_accessible :email, :username, :password, :password_confirmation, :password_digest
  has_many :questions
  has_secure_password validations: false
  has_many :quizzes

  validates :email, presence: true, uniqueness: true, format:/\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i
  validates :username, presence: true
  validates :password, presence: true
end