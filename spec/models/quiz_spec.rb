require 'spec_helper'

describe Quiz do
  it { should have_many(:quiz_settings) }
  it { should have_many(:questions).through(:quiz_settings) }
  it { should belong_to(:category) }
  it { should belong_to(:user) }
  it { should validate_presence_of(:quiz_name) }
  it { should validate_presence_of(:description) }
  #it { should validate_presence_of(:category_id) }
end