class ReviewsController < ApplicationController
  before_action :require_login
  before_action :set_categories 

  def create
    @quiz = Quiz.find_by(slug: params[:quiz_id])
    review = @quiz.reviews.build(params[:review].merge!(:user_id => current_user.id))
    if current_user == @quiz.user
      check_for_same_user
    else 
      if review.save
        flash[:notice] = "A new review was created!"
        redirect_to @quiz
      else
        #reloading reviews to display on show template of quizzes
        @reviews = @quiz.reviews.reload
        render 'quizzes/show'
      end
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

  #make sure that one can't review one's own quiz
  def check_for_same_user
    flash[:danger] = "Please don't review your own quiz!"
    @reviews = @quiz.reviews.reload
    render 'quizzes/show'
  end
end