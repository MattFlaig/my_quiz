class AnswersController < ApplicationController
  require 'pry'
  before_action :set_categories
  before_action :require_login
  before_action :restrict_access, only: [ :create, :destroy]
  before_action :set_question, only: [:create, :destroy]

  def create
    @answer = Answer.new(params[:answer])
    @answer.question = @question
    
    if @answer.save
      flash[:notice] = "A new answer was created!"
      redirect_to question_path(@question)
    else
      render 'questions/show'
    end
  end


  def destroy
    @answer = Answer.find_by(slug: params[:id])
    @answer.destroy
    flash[:notice] = "Answer has been deleted!"
    redirect_to question_path(@question)
  end

  private
  
  def set_question
    @question = Question.find_by(slug: params[:question_id])
  end

  def set_categories
    @categories = Category.all
  end

  def require_login
    unless logged_in?
      flash[:danger] = "Please login first!"
      redirect_to login_path
    end
  end

  def restrict_access
    @question = Question.find_by(slug: params[:question_id])
    if current_user != @question.user
      flash[:danger] = "You are not allowed to do that!"
      redirect_to questions_path
    end
  end
end
