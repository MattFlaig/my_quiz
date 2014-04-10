require 'spec_helper'

describe ReviewsController do
  describe "POST create" do
    let(:category) { Fabricate(:category) }
    let(:amanda) { Fabricate(:user)}
    let(:bob) { Fabricate(:user)}
    let(:question) { Fabricate(:question, user_id: amanda.id, category_id: category.id) }
    let(:quiz) { Fabricate(:quiz, user_id: amanda.id, category_id: category.id, question_ids: question.id) }

    context "when the current user is not the creator of the quiz" do
      before { set_current_user(bob) }
    
      context "with valid inputs" do
        before do
          post :create, review: Fabricate.attributes_for(:review), quiz_id: quiz
        end

        it "creates a review" do
          expect(Review.count).to eq(1)
        end
        it "creates a review associated with the video" do
          expect(Review.first.quiz).to eq(quiz)
        end
        it "creates a review associated with the signed in user" do
          expect(Review.first.user).to eq(bob)
        end
        it "redirects to the quiz show page" do
          expect(response).to redirect_to quiz
        end
      end

      context "with invalid inputs" do
        it "does not create a review" do
          post :create, review: {rating: 4}, quiz_id: quiz
          expect(Review.count).to eq(0)
        end
        it "renders the quiz/show template" do
          post :create, review: {rating: 4}, quiz_id: quiz
          expect(response).to render_template :show
        end
        it "sets @quiz" do
          post :create, review: {rating: 4}, quiz_id: quiz
          expect(assigns(:quiz)).to eq(quiz)
        end
        it "sets @reviews" do
          review = Fabricate(:review, quiz_id: quiz.id)
          post :create, review: {rating: 4}, quiz_id: quiz
          expect(assigns(:reviews)).to match_array([review])
        end
      end
    end

    context "when the current user is the creatorof the quiz" do
      before do
        set_current_user(amanda)
        post :create, review: Fabricate.attributes_for(:review), quiz_id: quiz
      end
      
      it "does not create a review" do
        expect(Review.count).to eq(0)
      end
      
      it "sets an error message" do
        expect(flash[:danger]).to eq("Please don't review your own quiz!")
      end
      it "renders the quiz/show template" do
        expect(response).to render_template :show
      end

      it "sets @quiz" do
        expect(assigns(:quiz)).to eq(quiz)
      end

      it "sets @reviews" do
        review = Fabricate(:review, quiz_id: quiz.id)
        post :create, review: {rating: 4}, quiz_id: quiz
        expect(assigns(:reviews)).to match_array([review])
      end
    end
  end
end