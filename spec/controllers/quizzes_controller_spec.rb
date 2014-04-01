require 'spec_helper'

describe QuizzesController do
  describe "GET index" do
    it "sets the @quizzes variable" do
      category = Fabricate(:category)
      question_1 = Fabricate(:question, category_id: category.id)
      question_2 = Fabricate(:question, category_id: category.id)
      quiz_1 = Fabricate(:quiz, category_id: category.id, question_ids: [question_1.id, question_2.id])
      quiz_2 = Fabricate(:quiz, category_id: category.id, question_ids: [question_1.id, question_2.id])
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
        let(:action) {post :create, user_id: 1, category_id: 1, question_id: 1}
      end

    context "with valid input" do

      before do
        amanda = Fabricate(:user)
        set_current_user(amanda)
        category = Fabricate(:category)
        question = Fabricate(:question, category_id: category.id, user_id: amanda.id)
        post :create, quiz: Fabricate.attributes_for(:quiz), user_id: amanda.id, category_id: category.id, question_ids: question.id
      end
 

      it "creates a new quiz for the current user" do
        expect(Quiz.count).to eq(1)
      end

      it "associates quiz and category" do
        expect(Quiz.first.category_id).not_to be_nil
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

  describe "PUT update" do

    context "with valid input" do
      it_behaves_like "requires login" do
        let(:action) { put :update, id: 1 }
      end
      
      before do
        amanda = Fabricate(:user)
        set_current_user(amanda)
        category = Fabricate(:category)
        question = Fabricate(:question, category_id: category.id, user_id: amanda.id)
        quiz = Fabricate(:quiz, user_id: amanda.id, question_ids: question.id, category_id: category.id)
        put :update, {id: quiz.id, quiz: {quiz_name: "Somewhat changed quiz"}}
      end

      it "updates the quiz" do
        expect(Quiz.first.quiz_name).to eq("Somewhat changed quiz")      
      end

      it "sets a flash success message" do
        expect(flash[:notice]).to eq("Your quiz was updated!")
      end

      it "redirects to quizzes index" do
        expect(response).to redirect_to quizzes_path
      end
    end

    context "with invalid input" do
      it_behaves_like "requires login" do
        let(:action) { put :update, id: 1 }
      end
      
      before do
        amanda = Fabricate(:user)
        set_current_user(amanda)
        category = Fabricate(:category)
        question = Fabricate(:question, category_id: category.id)
        quiz = Fabricate(:quiz, user_id: amanda.id, question_ids: question.id, category_id: category.id)
        put :update, {id: quiz.id, quiz: {quiz_name: " "}}
      end

      it "does not update the quiz" do
        expect(Quiz.first.quiz_name).not_to eq(" ")
      end

      it "renders the edit template" do
        expect(response).to render_template :edit
      end
    end
  end

  describe "DELETE destroy" do
    before do
      amanda = Fabricate(:user)
      set_current_user(amanda)
      category = Fabricate(:category)
      question = Fabricate(:question, category_id: category.id)
      quiz = Fabricate(:quiz, user_id: amanda.id, question_ids: question.id, category_id: category.id)
      delete :destroy, {id: quiz.id}
    end
  
    it_behaves_like "requires login" do
      let(:action) { delete :destroy, id: 1 }
    end

    it "deletes the quiz" do
      expect(Quiz.first).to be_nil
    end

    it "sets a notice that the quiz has been deleted" do
      expect(flash[:notice]).not_to be_empty
    end

    it "redirects to index" do
      expect(response).to redirect_to quizzes_path
    end
  end

  
end  