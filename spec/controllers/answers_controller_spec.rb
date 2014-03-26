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

end