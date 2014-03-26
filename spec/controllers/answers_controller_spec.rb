require 'spec_helper'

describe AnswersController do

  describe "GET new" do
    it "sets the @answer variable" do
      amanda = Fabricate(:user)
      set_current_user(amanda)
      get :new
      expect(assigns(:answer)).to be_instance_of(Answer)
    end

    it_behaves_like "requires login" do
      let(:action) {get :new}
    end

  end

  describe "POST create" do
    context "with valid input" do
      before do
        amanda = Fabricate(:user)
        set_current_user(amanda)
        category = Fabricate(:category)
        question = Fabricate(:question, user_id: amanda.id, category_id: category.id)
        post :create, answer: {answer_text: "Blabla!", question_id: question.id, correct?: 0}
      end

      it "creates a new answer" do
        expect(Answer.count).to eq(1)
      end

      it "sets a flash notice" do
        expect(flash[:notice]).not_to be_blank
      end

      it "redirects to question show page" do
        expect(response).to redirect_to questions_path#(id: question_id)
      end

    end

    context "with invalid input" do
      it "does not create the answer"
      it "renders the new template"
    end
  end
end