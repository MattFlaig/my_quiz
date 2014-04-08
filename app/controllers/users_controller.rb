class UsersController < ApplicationController
require 'pry'
before_action :set_categories, only: [:show]
#before_action :require_login, only: [:show]
before_action :set_user, only: [:show]

  def new
    @user = User.new
  end

  def show
   
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
  
  def set_categories
    @categories = Category.all
  end

  def require_login
    unless logged_in?
      flash[:danger] = "Please login first!"
      redirect_to login_path
    end
  end

  def set_user
    @user = User.find_by(slug: params[:id])
  end
end