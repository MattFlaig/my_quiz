class QuestionsController < ApplicationController
require 'pry'
before_action :require_login
before_action :set_categories
before_action :restrict_access, except: [:index, :new, :create]
before_action :set_question_by_slug, only: [:edit, :show ]


  def index
    @questions = Question.all
  end

  def show
    @answer = Answer.find_by_id(params[:answer])
  end

  def new
    @question = Question.new
  end

  def create
    @question = Question.new(params[:question].merge!(:user_id => current_user.id))
    
    if @question.save
      flash[:notice] = "Question succesfully created!"
      redirect_to questions_path
    else
      render 'new'
    end
  end

  def edit
  end

  def update
    if @question.update_attributes(params[:question])
      flash[:notice] = "Your question was updated!"
      redirect_to questions_path
    else
      render 'edit'
    end
  end

  def destroy
    @question = Question.find(params[:id])
    @question.destroy
    flash[:notice] = "Your question has been deleted!"
    redirect_to questions_path
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

  def set_question_by_slug
    @question = Question.find_by(slug: params[:id])
  end

  def set_question_and_answer
    @answer = Answer.find(params[:answer][:id])
    @question = Question.find(params[:id])
  end

  def save_answer_and_render
    @answer.save
    flash.now[:notice] = "The status of the answer with text '#{@answer.answer_text}' was changed"
    render 'show'
  end

  def require_login
    unless logged_in?
      flash[:danger] = "Please login first!"
      redirect_to login_path
    end
  end

  def restrict_access
    @question = Question.find_by(slug: params[:id])
    if current_user != @question.user
      flash[:danger] = "You are not allowed to do that!"
      redirect_to questions_path
    end
  end

  def set_categories
    @categories = Category.all
  end
end