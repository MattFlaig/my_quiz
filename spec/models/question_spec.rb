require 'spec_helper'

describe Question do
  it { should belong_to(:category) }
  it { should belong_to(:user) }
  it { should have_many(:answers) }
  it { should validate_presence_of(:question_text) }
  it { should validate_presence_of(:category_id) }
  
  it { should have_many(:quiz_settings) }
  it { should have_many(:quizzes).through(:quiz_settings) }
end