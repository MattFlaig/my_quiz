class AnswersController < ApplicationController
  before_action :set_categories 
  before_action :require_login 

  def new
    @answer = Answer.new
    @question = Question.find_by_id(params[:question])
    #@answer.question = @question
  end

  def create
    @answer = Answer.new
    @question = Question.find_by_id(params[:question_id])
    #@answer.question = @question
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