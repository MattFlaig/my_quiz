class QuestionsController < ApplicationController
before_action :require_login
before_action :set_categories

  def index
    @questions = current_user.questions.all
  end

  def show
    @question = Question.find(params[:id])
  end

  def new
    @question = current_user.questions.build
  end

  def create
    @question = current_user.questions.build(question_params)
    
    if @question.save
      flash[:notice] = "Question succesfully created!"
      redirect_to questions_path
    else
      render 'new'
    end
  end

  def set_correct_answer
    @question = Question.find(params[:id])
    @answer = Answer.find(params[:id])
    @answer.correct = 1
    @answer.save
    flash[:notice] = "The answer status of answer text #{@answer.answer_text.to_s} was set to correct"
    render 'show'
  end

  def set_incorrect_answer
    @question = Question.find(params[:id])
    @answer = Answer.find(params[:id])
    @answer.correct = 0
    @answer.save
    flash[:notice] = "The answer status of answer text #{@answer.answer_text.to_s} was set to incorrect"
    render 'show'
  end

  private

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