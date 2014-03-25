require 'spec_helper'

describe QuestionsController do
  
  describe "GET index" do
    it "should set the @questions variable" do
      amanda = Fabricate(:user)
      set_current_user(amanda)
      category = Fabricate(:category)
      question_1 = Fabricate(:question, category_id: category.id, user_id: amanda.id)
      question_2 = Fabricate(:question, category_id: category.id, user_id: amanda.id)
      get :index
      expect(assigns[:questions]).to match_array([question_1, question_2])
    end
    
    it_behaves_like "requires login" do
      let(:action) {get :index}
    end
  end

  describe "GET show" do
    it "sets the @question variable" do
      amanda = Fabricate(:user)
      set_current_user(amanda)
      category = Fabricate(:category)
      question = Fabricate(:question, category_id: category.id, user_id: amanda.id)
      get :show, id: question.id 
      expect(assigns(:question)).to eq(question)
    end

    it_behaves_like "requires login" do
      let(:action) {get :show, id: 1}
    end
  end

  describe "GET new" do
    it "sets the @question variable to be an instance of question" do
      amanda = Fabricate(:user)
      set_current_user(amanda)
      get :new
      expect(assigns(:question)).to be_instance_of(Question)
    end
  end

  describe "POST create" do
    context "with valid input" do
      before do
        amanda = Fabricate(:user)
        set_current_user(amanda)
        category = Fabricate(:category)
        post :create, question: {question_text: "Blabla?", user_id: amanda.id, category_id: category.id}
      end

      it_behaves_like "requires login" do
        let(:action) {post :create, user_id: 1}
      end

      it "creates a new question for the current user" do
        expect(Question.count).to eq(1)
      end
       
      it "sets a flash message that the question was created" do
        expect(flash[:notice]).to eq("Question succesfully created!")
      end

      it "redirects to questions path" do
        expect(response).to redirect_to questions_path
      end
    end

    context "with invalid input" do
      before do
        amanda = Fabricate(:user)
        set_current_user(amanda)
        category = Fabricate(:category)
        post :create, question: {user_id: amanda.id, category_id: category.id}
      end

      it "does not create a new question" do
        expect(Question.count).to eq(0)
      end

      it "renders the new template" do
        expect(response).to render_template :new
      end
    end
  end
end