class UsersController < ApplicationController
  def new
    @user = User.new
  end

  def create
    @user = User.new(params[:user])
    if @user.save
      flash[:notice] = "Your user account has been created!"
      redirect_to login_path
    else
      render "new"
    end 
  end

  private

  def user_params
    params.require(:user).permit(:username, :email,:password, :password_confirmation, :password_digest)
  end
end