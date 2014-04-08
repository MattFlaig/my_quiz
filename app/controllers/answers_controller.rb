class AnswersController < ApplicationController
  require 'pry'
  before_action :set_categories 
  before_action :require_login 
  before_action :restrict_access, only: [:new, :create, :edit, :update, :delete]
  

  def new
    @answer = Answer.new
    @question = Question.find_by(slug: params[:question])
  end

  def create
    @question = Question.find_by_id(params[:question_id])
    @answer = Answer.new(params[:answer].merge!(:question_id => @question.id))
    
    if @answer.save
      flash[:notice] = "A new answer was created!"
      redirect_to question_path(@answer.question.id)
    else
      render 'new'
    end
    
  end

  def edit
    @question = Question.find_by_id(params[:question_id])
    @answer = Answer.find_by(slug: params[:id])
  end

  def update
    @question = Question.find_by_id(params[:question_id])
    @answer = Answer.find(params[:id])
    if @answer.update_attributes(params[:answer])
      flash[:notice] = "Your answer was updated!"
      redirect_to question_path(@answer.question_id)
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
      @answer = Answer.find_by(slug: params[:id])
      @question = @answer.question
      if current_user != @question.user
        flash[:danger] = "You are not allowed to do that!"
        redirect_to questions_path
      end
    else
      @question = Question.find_by(slug: params[:question_id])
      if current_user != @question.user
        flash[:danger] = "You are not allowed to do that!"
        redirect_to questions_path
      end
    end

  end
end