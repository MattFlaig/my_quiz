class QuizzesController < ApplicationController
  require 'pry'

  before_action :set_categories 
  before_action :require_login , except: [:index, :start, :question, :answer, :score]
  before_action :restrict_access, only: [:edit, :update, :delete]

  def index
    @quizzes = Quiz.all
  end

  def new
    @quiz = current_user.quizzes.build
    @category = Category.find_by_id(params[:category])
  end

  def show
    @quiz = Quiz.find(params[:id])
    @reviews = @quiz.reviews
  end

  def create
    set_variables_for_create

    if @quiz.save
      flash[:notice] = "Your quiz was succesfully created!"
      redirect_to quizzes_path
    else
      render 'new'
    end
    #binding.pry
  end

  def edit
    @quiz = Quiz.find(params[:id])
    @category = @quiz.category
  end

  def update
    @quiz = current_user.quizzes.find(params[:id])
    @category = @quiz.category
    if @quiz.update_attributes(params[:quiz])
      flash[:notice] = "Your quiz was updated!"
      redirect_to quizzes_path
    else
      render 'edit'
    end
  end

  def destroy
    @quiz = current_user.quizzes.find(params[:id])
    @quiz.destroy
    flash[:notice] = "Your quiz has been deleted!"
    redirect_to quizzes_path
  end

  def start
    start_variables_for_quiz
    redirect_to :action => "question", :id => @quiz.id
  end

  def question
    prepare_quiz
    @answers = @current_question.answers
    session[:current_question] = @number
    if @answers.empty? || @answers.length < 2
      flash[:danger] = "There are not enough answers specified for question #{@current_question.question_text} Please create some more!"
      redirect_to question_path(id: @current_question.id)
    end
  end

  def answer
    prepare_quiz
    @answer_choice = Answer.find_by_id(params[:answer])
    if @answer_choice && @answer_choice.correct == 1
      session[:correct_answers] += 1
    end
    manage_redirect
  end

  def score
    prepare_quiz
    @score = session[:correct_answers]
    @percent = ((@score.to_f / @length_of_quiz.to_f) * 100).to_i
    if @percent >= 80
      flash.now[:notice] = "Congratulations! This was very good!"
    elsif  @percent < 79 && @percent != 0
      flash.now[:notice] = "Not bad!"
    else
      flash.now[:danger] = "It seems you need more practice."
    end
  end

  
  private

  def start_variables_for_quiz
    @quiz = Quiz.find(params[:id])
    session[:current_question] = 0
    session[:correct_answers] = 0
  end

  def prepare_quiz
    @quiz = Quiz.find(params[:id])
    @length_of_quiz = @quiz.questions.length
    @number = session[:current_question]
    @current_question = @quiz.questions[session[:current_question]]
  end

  def manage_redirect
    if @number+1 < @length_of_quiz
      session[:current_question] += 1
      redirect_to :action => "question", :id => @quiz.id
    else
      redirect_to :action => "score", :id => @quiz.id
    end
  end

  def set_variables_for_create
    @category = Category.find_by_id(params[:category_id])
    @quiz = current_user.quizzes.build(params[:quiz])
    @quiz.category = @category
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
    @quiz = Quiz.find(params[:id])
    if current_user != @quiz.user
      flash[:danger] = "You are not allowed to do that!"
      redirect_to quizzes_path
    end
  end

end