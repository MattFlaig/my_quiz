require 'spec_helper'

describe CategoriesController do

  describe "GET new " do
    it_behaves_like "requires login" do
      let(:action) {get :new}
    end

    it "sets @category to be an instance of category" do
      amanda = Fabricate(:user)
      set_current_user(amanda)
      get :new
      expect(assigns(:category)).to be_instance_of(Category)
    end
  end

end