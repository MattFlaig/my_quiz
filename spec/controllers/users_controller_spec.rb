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
      it "creates a user"
      it "sets a flash message that the user was successfully created"
      it "redirects to the login path"
    end

    context "with invalid input" do
      it "does not create the user"
      it "sets an error message"
      it "renders the new template"
    end
  end
end