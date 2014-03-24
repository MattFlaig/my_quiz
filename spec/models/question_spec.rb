require 'spec_helper'

describe Question do
  it {should belong_to (:category)}
  it {should have_many (:answers)}
  it {should validate_presence_of (:question_text)}
  it {should validate_presence_of (:category_id)}
end