class CategoriesController < ApplicationController
before_action :require_login
before_action :set_categories
  # def index
  #   @categories = Category.all
  # end
  def new
    @category = Category.new
  end

private

  def require_login
    unless logged_in?
      flash[:danger] = "Please login first!"
      redirect_to login_path
    end
  end

  def set_categories
    @categories = Category.all
  end
  
end