class QuizzesController < ApplicationController
  require 'pry'

  before_action :set_categories 
  before_action :require_login , except: [:index]

  def index
    @quizzes = Quiz.all
  end

  def new
    @quiz = current_user.quizzes.build
    @category = Category.find_by_id(params[:category])
  end

  def create
    @category = Category.find_by_id(params[:category_id])
    @quiz = current_user.quizzes.build(quiz_params)
    @quiz.category = @category

    if @quiz.save
      flash[:notice] = "Your quiz was succesfully created!"
      redirect_to quizzes_path
    else
      render 'new'
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

  def quiz_params
    params.require(:quiz).permit(:quiz_name, :description, :category_id)
  end
end