require 'spec_helper'

describe ReviewsController do
  describe "POST create" do
    let(:category) { Fabricate(:category) }
    let(:amanda) { Fabricate(:user)}
    let(:question) { Fabricate(:question, user_id: amanda.id, category_id: category.id) }
    let(:quiz) { Fabricate(:quiz, user_id: amanda.id, category_id: category.id, question_ids: question.id) }

    before { set_current_user(amanda) }

    context "with valid inputs" do
      before do
        post :create, review: Fabricate.attributes_for(:review), quiz_id: quiz.id
      end

      it "creates a review" do
        expect(Review.count).to eq(1)
      end
      it "creates a review associated with the video" do
        expect(Review.first.quiz).to eq(quiz)
      end
      it "creates a review associated with the signed in user" do
        expect(Review.first.user).to eq(amanda)
      end
      it "redirects to the quiz show page" do
        expect(response).to redirect_to quiz
      end
    end

    context "with invalid inputs" do
      it "does not create a review" do
        post :create, review: {rating: 4}, quiz_id: quiz.id
        expect(Review.count).to eq(0)
      end
      it "renders the quiz/show template" do
        post :create, review: {rating: 4}, quiz_id: quiz.id
        expect(response).to render_template :show
      end
      it "sets @quiz" do
        post :create, review: {rating: 4}, quiz_id: quiz.id
        expect(assigns(:quiz)).to eq(quiz)
      end
      it "sets @reviews" do
        review = Fabricate(:review, quiz_id: quiz.id)
        post :create, review: {rating: 4}, quiz_id: quiz.id
        expect(assigns(:reviews)).to match_array([review])
      end
    end
    
  end
end