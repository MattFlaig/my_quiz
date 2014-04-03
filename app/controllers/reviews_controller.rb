class ReviewsController < ApplicationController
  before_action :require_login
  before_action :set_categories 

  def create
    @quiz = Quiz.find(params[:quiz_id])
    review = @quiz.reviews.build(params[:review].merge!(:user_id => current_user.id))
   
    if review.save
      redirect_to @quiz
    else
      @reviews = @quiz.reviews.reload
      render 'quizzes/show'
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
end