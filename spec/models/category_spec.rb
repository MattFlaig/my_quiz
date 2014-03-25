require 'spec_helper'

describe Category do
  it {should have_many(:questions)}
  it {should have_many(:quizzes)}
end