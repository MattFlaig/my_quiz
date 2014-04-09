class AnswersController < ApplicationController
  require 'pry'
  before_action :set_categories
  before_action :require_login
  #before_action :restrict_access, only: [:new, :create, :edit, :update, :delete]
  before_action :set_question, only: [:new]

  def new
    @answer = Answer.new
  end

  def create
    @question = Question.find(params[:question_id])
    @answer = Answer.new(params[:answer].merge!(:question_id => @question.id))
    
    if @answer.save
      flash[:notice] = "A new answer was created!"
      redirect_to question_path(@answer.question.id)
    else
      render 'new'
    end
    
  end

  def edit
    @question = Question.find(params[:question_id])
    @answer = Answer.find(params[:id])
  end

  def update
    @question = Question.find(params[:question_id])
    @answer = Answer.find(params[:id])
    if @answer.update_attributes(params[:answer])
      flash[:notice] = "Your answer was updated!"
      redirect_to question_path(@answer.question.id)
    else
      render 'edit'
    end
  end

  def destroy
    @question = Question.find_by_id(params[:question_id])
    @answer = Answer.find(params[:id])
    @answer.destroy
    flash[:notice] = "Answer has been deleted!"
    redirect_to question_path(@answer.question_id)
  end

  private
  
  def set_question
    @question = Question.find_by(slug: params[:id])
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
    if params[:answer]
      @answer = Answer.find(params[:id])
      @question = @answer.question
      not_allowed
    elsif params[:question_id]
      @question = Question.find(params[:question_id])
      not_allowed
    else
      @question = Question.find(params[:question])
      not_allowed
    end

  end

  def not_allowed
    if current_user != @question.user
      flash[:danger] = "You are not allowed to do that!"
      redirect_to questions_path
    end
  end
end
