shared_examples "requires login" do
  it "redirects to the login page" do
    session[:user_id] = nil
    action
    expect(response).to redirect_to login_path
  end
end
