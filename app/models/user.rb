class User < ActiveRecord::Base
  include Slugable

  attr_accessible :email, :username, :password, :password_confirmation, :password_digest
  has_many :questions
  has_secure_password validations: false
  has_many :quizzes
  has_many :reviews


  validates :email, uniqueness: true, format:/\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i
  validates :username, presence: true
  validates :email, presence: true
  validates :password, presence: true

  slugable_column :username
end