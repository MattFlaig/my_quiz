class QuestionsController < ApplicationController
before_action :require_login, except: [:index]
before_action :set_categories
  def index
    @questions = Question.all
    @categories = Category.all
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