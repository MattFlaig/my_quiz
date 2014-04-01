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
    it_behaves_like "requires login" do
      let(:action) {post :create, question_id: 1}
    end

    context "with valid input" do
      let(:category) { Fabricate(:category) }
      let(:amanda) { Fabricate(:user)}
      let(:question) { Fabricate(:question, user_id: amanda.id, category_id: category.id) }

      before do
        set_current_user(amanda) 
        post :create, {id: 1, answer_text: "Blabla!", question_id: question.id, correct: 0 }
      end

      it "creates a new answer" do
        expect(Answer.count).to eq(1)
      end

      it "sets a flash notice" do
        expect(flash[:notice]).not_to be_blank
      end

      it "redirects to questions index page" do
        expect(response).to redirect_to question_path(Answer.first.question_id)
      end
    end

    context "with invalid input" do
      let(:category) { Fabricate(:category) }
      let(:amanda) { Fabricate(:user)}
      let(:question) { Fabricate(:question, user_id: amanda.id, category_id: category.id) }

      before do
        set_current_user(amanda) 
        post :create, {id: 1, question_id: question.id, correct: 0 }
      end

      it "does not create the answer" do
        expect(Answer.count).to eq(0)
      end

      it "renders the new template" do
        expect(response).to render_template :new
      end
    end
  end

  describe "PUT update" do
    context "with valid input" do
      let(:category) { Fabricate(:category) }
      let(:amanda) { Fabricate(:user)}
      let(:question) { Fabricate(:question, user_id: amanda.id, category_id: category.id) }
      let(:answer) { Fabricate(:answer, question_id: question.id, correct: 0) }

      before do
        set_current_user(amanda) 
        patch :update, {id: answer.id, answer: {answer_text: "Different answer text", question_id: question.id} }
      end
      
      it "updates the answer" do
        expect(Answer.first.answer_text).to eq("Different answer text")
      end

      it "sets a notice" do
        expect(flash[:notice]).not_to be_blank
      end

      it "redirects to questions index" do
        expect(response).to redirect_to question_path(answer.question_id)
      end
    end

    context "with invalid input" do
      let(:category) { Fabricate(:category) }
      let(:amanda) { Fabricate(:user)}
      let(:question) { Fabricate(:question, user_id: amanda.id, category_id: category.id) }
      let(:answer) { Fabricate(:answer, question_id: question.id, correct: 0) }

      before do
        set_current_user(amanda) 
        patch :update, {id: answer.id, answer: {answer_text: " ", question_id: question.id} }
      end

      it "does not update the answer" do
        expect(Answer.first.answer_text).to eq(answer.answer_text)
      end

      it "renders the edit template" do 
        expect(response).to render_template :edit
      end
    end
  end

end