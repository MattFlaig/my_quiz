require 'spec_helper'

describe UsersController do
  describe "GET new" do
    it "should set the @user variable" do
      get :new
      expect(assigns[:user]).to be_instance_of(User)
    end
  end

  describe "POST create" do
    context "with valid input" do
      before do
        post :create, user: Fabricate.attributes_for(:user)
      end
 
      it "creates a user" do
        expect(User.count).to eq (1)
      end

      it "sets a flash message that the user was successfully created" do
        expect(flash[:notice]).to eq("Your user account has been created!")
      end

      it "redirects to the login path" do
        expect(response).to redirect_to login_path
      end
    end

    context "with invalid input" do
      it "does not create the user" do
        post :create, user: {username: "Invalid user"}
        expect(User.first).to be_nil
      end
        
      it "renders the new template" do
        post :create, user: {username: "Invalid user"}
        expect(response).to render_template :new
      end
    end
  end
end