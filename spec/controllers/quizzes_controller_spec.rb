require 'spec_helper'

describe QuizzesController do
  describe "GET index" do
    it "sets the @quizzes variable" do
      category = Fabricate(:category)
      quiz_1 = Fabricate(:quiz, category_id: category.id)
      quiz_2 = Fabricate(:quiz, category_id: category.id)
      get :index
      expect(assigns[:quizzes]).to match_array([quiz_1, quiz_2])
    end
  end

  describe "GET new" do

    it_behaves_like "requires login" do
      let(:action) {get :new}
    end

    it "sets @quiz to be an instance of quiz" do
      amanda = Fabricate(:user)
      set_current_user(amanda)
      get :new
      expect(assigns(:quiz)).to be_instance_of(Quiz)
    end

    it "sets @category" do #this test case seems strange
      amanda = Fabricate(:user)
      set_current_user(amanda)
      category = Fabricate(:category)
      get :new #, id: category.id
      expect(Category.first.id).to eq(category.id)
    end
  end

  describe "POST create" do

      it_behaves_like "requires login" do
        let(:action) {post :create, user_id: 1, category_id: 1}
      end

    context "with valid input" do

      before do
        amanda = Fabricate(:user)
        set_current_user(amanda)
        category = Fabricate(:category)
        post :create, quiz: Fabricate.attributes_for(:quiz), user_id: amanda.id, category_id: category.id
      end

      it "creates a new quiz for the current user" do
        expect(Quiz.count).to eq(1)
      end

      it "sets a success message that the quiz was created" do
        expect(flash[:notice]).not_to be_blank
      end

      it "redirects to quizzes path" do
        expect(response).to redirect_to quizzes_path
      end
    end

    context "with invalid input" do
      before do
        amanda = Fabricate(:user)
        set_current_user(amanda)
        category = Fabricate(:category)
        post :create, quiz: {user_id: amanda.id, category_id: category.id}
      end

      it "does not create the user" do
        expect(Quiz.first).to be_nil
      end

      it "renders the new template" do
        expect(response).to render_template :new
      end
    end
  end
  
end  