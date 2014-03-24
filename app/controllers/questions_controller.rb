class QuestionsController < ApplicationController
before_action :require_login, except: [:index]

  def index
    @questions = Question.all
    @categories = Category.all
  end

  def new
    @question = Question.new
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

  def require_login
    unless logged_in?
      flash[:danger] = "Please login first!"
      redirect_to login_path
    end
  end
end