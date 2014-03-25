require 'spec_helper'

describe SessionsController do
  describe "POST create" do
    context "with valid input" do
      it "puts the user in the session" do
        amanda = Fabricate(:user)
        post :create, email: amanda.email, password: amanda.password
        expect(session[:user_id]).to eq(amanda.id)
      end
      it "sets a flash login notice" do
        amanda = Fabricate(:user)
        post :create, email: amanda.email, password: amanda.password
        expect(flash[:notice]).not_to be_blank
      end
      it "redirects to index" do
        amanda = Fabricate(:user)
        post :create, email: amanda.email, password: amanda.password
        expect(response).to redirect_to quizzes_path
      end
    end

    context "with invalid input" do
      before do
        amanda = Fabricate(:user)
        post :create, email: amanda.email
      end

      it "does not put the user in the session" do
        expect(session[:user_id]).to be_nil
      end

      it "sets an error message" do
        expect(flash[:danger]).not_to be_blank
      end

      it "renders the new template" do
        expect(response).to render_template :new
      end  
    end
  end

  describe "GET destroy" do
    before do
      amanda = Fabricate(:user)
      get :destroy, user_id: amanda.id
    end
    
    it "sets the session to nil" do
      expect(session[:user_id]).to be_nil
    end

    it "sets a flash logout notice" do
      expect(flash[:notice]).not_to be_blank
    end
  
    it "redirects to root path" do
      expect(response).to redirect_to root_path
    end    
  end
end

