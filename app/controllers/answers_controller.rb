class AnswersController < ApplicationController
  before_action :set_categories 
  before_action :require_login 

  def new
    @answer = Answer.new
    @question = Question.find_by_id(params[:question])
  end

  def create
    @question = current_user.questions.find_by_id(params[:question_id])
    @answer = Answer.new(answer_params)
    @answer.question = @question
    
    
    if @answer.save
      flash[:notice] = "A new answer was created!"
      redirect_to questions_path
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

  def answer_params
    params.require(:answer).permit(:answer_text, :question_id, :correct?)
  end
end