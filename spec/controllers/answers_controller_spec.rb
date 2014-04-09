require 'spec_helper'

describe AnswersController do

  describe "POST create" do

    context "with valid input" do
      let(:category) { Fabricate(:category) }
      let(:amanda) { Fabricate(:user)}
      let(:question) { Fabricate(:question, user_id: amanda.id, category_id: category.id) }

      before do
        set_current_user(amanda) 
        post :create, { :answer => { id: 1, answer_text: "Hopefully works", correct: 0 }, question_id: question}
      end

      it_behaves_like "requires login" do
        let(:action) {post :create, question_id: question}
      end

      it "creates a new answer" do
        expect(Answer.count).to eq(1)
      end

      it "sets a flash notice" do
        expect(flash[:notice]).not_to be_blank
      end

      it "redirects to questions index page" do
        expect(response).to redirect_to question_path(id: question)
      end
    end

    context "with invalid input" do
      let(:category) { Fabricate(:category) }
      let(:amanda) { Fabricate(:user)}
      let(:question) { Fabricate(:question, user_id: amanda.id, category_id: category.id) }

      before do
        set_current_user(amanda) 
        post :create, { :answer => { id: 1, correct: 0 }, question_id: question }
      end

      it "does not create the answer" do
        expect(Answer.count).to eq(0)
      end

      it "renders the new template" do
        expect(response).to render_template 'questions/show'
      end
    end
  end

  describe "DELETE destroy" do
    let(:category) { Fabricate(:category) }
    let(:amanda) { Fabricate(:user)}
    let(:question) { Fabricate(:question, user_id: amanda.id, category_id: category.id) }
    let(:answer) { Fabricate(:answer, question_id: question, correct: 0) }

      before do
        set_current_user(amanda) 
        delete :destroy, {id: answer, question_id: question}
      end
  
    it_behaves_like "requires login" do
      let(:action) { delete :destroy, id: answer, question_id: question }
    end

    it "deletes the answer" do
      expect(Answer.first).to be_nil
    end

    it "sets a notice that the answer has been deleted" do
      expect(flash[:notice]).not_to be_empty
    end

    it "redirects to show question path" do 
      expect(response).to redirect_to question_path(id: question)
    end
  end
end