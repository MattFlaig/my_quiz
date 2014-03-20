require 'spec_helper'

describe QuestionsController do
  
  describe "GET index" do
    it "should set the @questions variable" do
      category = Category.create(category_name: "Stupid category")
      question_1 = Question.create(question_text: "Really?", category_id: category.id)
      question_2 = Question.create(question_text: "Really not?", category_id: category.id)
      get :index
      expect(assigns[:questions]).to match_array([question_1, question_2])
    end

    it "should set the @categories variable" do
      category_1 = Category.create(category_name: "Stupid category")
      category_2 = Category.create(category_name: "Clever category")
      get :index
      expect(assigns[:categories]).to match_array([category_1, category_2])
    end

  end
end