class SessionsController < ApplicationController
  def new
  end
  
  def create
    user = User.find_by_email(params[:email])
    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
      flash[:notice] = "You are logged in now!"
      redirect_to questions_path
    else
      flash[:danger] = "There is something wrong with your input data!"
      render "new"
    end
  end

  def destroy
    session[:user_id] = nil
    flash[:notice] = "You have been logged out successfully!"
    redirect_to root_path
  end
end
