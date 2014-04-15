require 'spec_helper'

describe Quiz do #model which should be tested
  it { should have_many(:quiz_settings) } #testing associations with shoulda-matchers (gem) syntax
  it { should have_many(:questions).through(:quiz_settings) }
  it { should belong_to(:category) }
  it { should belong_to(:user) }
  it { should validate_presence_of(:quiz_name) }
  it { should validate_presence_of(:description) }
end