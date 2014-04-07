class AnswersController < ApplicationController
  require 'pry'
  before_action :set_categories 
  before_action :require_login 

  def new
    @answer = Answer.new
    @question = Question.find_by_id(params[:question])
  end

  def create
    @question = Question.find_by_id(params[:question_id])
    @answer = Answer.new(params[:answer])
    @answer.question = @question
    
    if @answer.save
      flash[:notice] = "A new answer was created!"
      redirect_to question_path(@answer.question_id)
    else
      render 'new'
    end
    #binding.pry
  end

  def edit
    @question = Question.find(params[:id])
    @answer = Answer.find(params[:answer][:id])
  end

  def update
    @question = current_user.questions.find_by_id(params[:question_id])
    @answer = Answer.find(params[:id])
    if @answer.update_attributes(params[:answer])
      flash[:notice] = "Your answer was updated!"
      redirect_to question_path(@answer.question_id)
    else
      render 'edit'
    end
  end

  def destroy
    @question = current_user.questions.find_by_id(params[:question_id])
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

  # def answer_params
  #   params.require(:answer).permit(:answer_text, :question_id, :correct)
  # end
end