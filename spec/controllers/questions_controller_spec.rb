require 'spec_helper'

describe QuestionsController do
  
  describe "GET index" do
    it "should set the @questions variable" do
      category = Fabricate(:category)
      question_1 = Fabricate(:question, category_id: category.id)
      question_2 = Fabricate(:question, category_id: category.id)
      get :index
      expect(assigns[:questions]).to match_array([question_1, question_2])
    end

    it "should set the @categories variable" do
      category_1 = Fabricate(:category)
      category_2 = Fabricate(:category)
      get :index
      expect(assigns[:categories]).to match_array([category_1, category_2])
    end
  end

  describe "GET new" do
    it "sets the @question variable to be an instance of question" do
      get :new
      expect(assigns(:question)).to be_instance_of(Question)
    end
  end

  describe "POST create" do
  

  end
end