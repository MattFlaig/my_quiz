class QuestionsController < ApplicationController
require 'pry'
before_action :require_login
before_action :set_categories

  def index
    @questions = current_user.questions.all
  end

  def show
    @question = current_user.questions.find(params[:id])
    #@answer = Answer.find(params[:id])
  end

  def new
    @question = current_user.questions.build
  end

  def create
    @question = current_user.questions.build(params[:question])
    
    if @question.save
      flash[:notice] = "Question succesfully created!"
      redirect_to questions_path
    else
      render 'new'
    end
  end

  def set_correct_answer
    set_question_and_answer
    @answer.correct = 1
    save_answer_and_render
  end

  def set_incorrect_answer
    set_question_and_answer
    @answer.correct = 0
    save_answer_and_render
  end

  private

  def set_question_and_answer
    @answer = Answer.find(params[:answer][:id])
    @question = current_user.questions.find(params[:id])
  end

  def save_answer_and_render
    @answer.save
    flash[:notice] = "The status of the answer with text '#{@answer.answer_text}' was changed"
    render 'show'
  end

  def question_params
    params.require(:question).permit(:question_text, :category_id)
  end

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