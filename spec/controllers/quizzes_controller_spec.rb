require 'spec_helper'
require 'pry'

describe QuizzesController do #gives name of controller to be tested
  describe "GET index" do #gives action to be tested
    it "sets the @quizzes variable" do #specifies first test case
      category = Fabricate(:category) #fabricate a fake test object for category (see spec/fabricators)
      question_1 = Fabricate(:question, category_id: category.id) #same for question
      question_2 = Fabricate(:question, category_id: category.id)
      quiz_1 = Fabricate(:quiz, category_id: category.id, question_ids: [question_1.id, question_2.id]) #same for quiz
      quiz_2 = Fabricate(:quiz, category_id: category.id, question_ids: [question_1.id, question_2.id])
      get :index #calling the action in controller with our fake test data
      expect(assigns[:quizzes]).to match_array([quiz_1, quiz_2]) #expected result
    end
  end

  describe "GET new" do
    it_behaves_like "requires login" do #shared example for simulating require login before_action (see spec/support/shared_examples.rb)
      let(:action) {get :new }
    end

    let(:category) { Fabricate(:category) } #let-syntax to predifine objects which are available for all test cases and only called when needed (better performance)
    let(:amanda) { Fabricate(:user)}
    let(:question_1) { Fabricate(:question, user_id: amanda.id, category_id: category.id) }
    let(:question_2) { Fabricate(:question, user_id: amanda.id, category_id: category.id) }
    let(:answer_1) { Fabricate(:answer, question_id: question_1.id, correct: 0) }
    let(:answer_2) { Fabricate(:answer, question_id: question_1.id, correct: 1) }
    
    before do
      set_current_user(amanda) #setting current user with macro (see spec/support/macros.rb)
    end

    it "does not show questions with less than 2 answers" do #test for check_for_answers method (see spec/support/macros.rb)
      questions = [question_1,question_2]
      answers = [answer_1, answer_2]
      expect(check_for_answers(questions)).to eq([question_1])
    end

    it "sets @quiz to be an instance of quiz" do
      get :new, category: category
      expect(assigns(:quiz)).to be_instance_of(Quiz)
    end

    it "sets @category" do 
      get :new, category: category
      expect(assigns[:category]).to eq(category)
    end
  end

  describe "GET show" do

    let(:category) { Fabricate(:category) } #let-syntax to predifine objects which are available for all test cases and only called when needed (better performance)
    let(:amanda) { Fabricate(:user)}
    let(:question) { Fabricate(:question, user_id: amanda.id, category_id: category.id) }
    let(:quiz) { Fabricate(:quiz, user_id: amanda.id, question_ids: question.id, category_id: category.id) }

    it_behaves_like "requires login" do
      let(:action) {get :show, id: quiz}
    end

    it "sets the quiz variable" do
      set_current_user(amanda)
      get :show, id: quiz
      expect(assigns(:quiz)).to eq(quiz)
    end
  end

   describe "POST create" do 

    context "with valid input" do #specify input context
      let(:amanda) { Fabricate(:user)}
      let(:category) { Fabricate(:category) }
      let(:question_1) { Fabricate(:question, user_id: amanda.id, category_id: category.id) }

      before do #before block with code needed in several test cases to avoid repetition
        set_current_user(amanda)
        post :create, quiz: Fabricate.attributes_for(:quiz, user_id: amanda.id, question_ids: question_1.id ), category_id: category.id
      end

      it_behaves_like "requires login" do
        let(:action) {post :create, user_id: 1, category_id: 1, question_ids: 1}
      end 

      it "creates a new quiz for the current user" do
        expect(Quiz.count).to eq(1)
      end

      it "associates quiz and category" do
        expect(assigns(:category)).to eq(Quiz.first.category)
      end

      it "sets a success message that the quiz was created" do
        expect(flash[:notice]).not_to be_blank
      end

      it "redirects to quizzes path" do
        expect(response).to redirect_to quizzes_path
      end
    end

    context "with invalid input" do #specify context if input is not valid
      let(:category) { Fabricate(:category) }
      let(:amanda) { Fabricate(:user)}
      let(:question_1) { Fabricate(:question, user_id: amanda.id, category_id: category.id) }
      let(:question_2) { Fabricate(:question, user_id: amanda.id, category_id: category.id) }
      let(:answer_1) { Fabricate(:answer, question_id: question_1.id, correct: 0) }
      let(:answer_2) { Fabricate(:answer, question_id: question_1.id, correct: 1) }
      
      before do
        set_current_user(amanda)
        post :create, quiz: {user_id: amanda.id}, category_id: category.id
      end

      it "does not create the quiz" do
        expect(Quiz.first).to be_nil
      end

      it "renders the new template" do
        expect(response).to render_template :new
      end

      it "does not show questions with less than 2 answers" do 
        questions = [question_1,question_2]
        answers = [answer_1, answer_2]
        expect(check_for_answers(questions)).to eq([question_1])
      end
    end
  end

  describe "PUT update" do
    context "with valid input" do

      let(:category) { Fabricate(:category) }
      let(:amanda) { Fabricate(:user)}
      let(:question_1) { Fabricate(:question, user_id: amanda.id, category_id: category.id) }
      let(:question_2) { Fabricate(:question, user_id: amanda.id, category_id: category.id) }
      let(:answer_1) { Fabricate(:answer, question_id: question_1.id, correct: 0) }
      let(:answer_2) { Fabricate(:answer, question_id: question_1.id, correct: 1) }
      let(:quiz) { Fabricate(:quiz, user_id: amanda.id, question_ids: question_1.id, category_id: category.id) }
      
      before do
        set_current_user(amanda)
        put :update, {id: quiz, quiz: {quiz_name: "Somewhat changed quiz"}}
      end

      it_behaves_like "requires login" do
        let(:action) { put :update, id: quiz }
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

      it "does not show questions with less than 2 answers" do 
        questions = [question_1,question_2]
        answers = [answer_1, answer_2]
        expect(check_for_answers(questions)).to eq([question_1])
      end
    end

    context "with invalid input" do

      let(:category) { Fabricate(:category) }
      let(:amanda) { Fabricate(:user)}
      let(:question_1) { Fabricate(:question, user_id: amanda.id, category_id: category.id) }
      let(:question_2) { Fabricate(:question, user_id: amanda.id, category_id: category.id) }
      let(:answer_1) { Fabricate(:answer, question_id: question_1.id, correct: 0) }
      let(:answer_2) { Fabricate(:answer, question_id: question_1.id, correct: 1) }
      let(:quiz) { Fabricate(:quiz, user_id: amanda.id, question_ids: question_1.id, category_id: category.id) }
      
      before do
        set_current_user(amanda)
        put :update, {id: quiz, quiz: {quiz_name: " "}}
      end

      it_behaves_like "requires login" do
        let(:action) { put :update, id: quiz }
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
      delete :destroy, {id: quiz}
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

