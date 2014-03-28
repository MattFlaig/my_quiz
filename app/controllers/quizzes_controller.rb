class QuizzesController < ApplicationController
  require 'pry'

  before_action :set_categories 
  before_action :require_login , except: [:index]

  def index
    @quizzes = Quiz.all
  end

  def new
    @quiz = current_user.quizzes.build
    @category = Category.find_by_id(params[:category])
    @questions = Question.all
  end

  def show
    @quiz = Quiz.find(params[:id])
  end

  def create
    @category = Category.find_by_id(params[:category_id])
    @quiz = current_user.quizzes.build(quiz_params)
    @quiz.category = @category
    @questions = @category.questions
    @quiz.questions = @questions
    #binding.pry

    if @quiz.save
      flash[:notice] = "Your quiz was succesfully created!"
      redirect_to quizzes_path
    else
      render 'new'
    end
  end

  def start
    @quiz = Quiz.find(params[:id])
    session[:current_question] = 0
    session[:correct_answers] = 0
    redirect_to :action => "question", :id => @quiz.id
  end

  def question
    @quiz = Quiz.find(params[:id])
    @length_of_quiz = @quiz.questions.length
    @number = session[:current_question]
    @current_question = @quiz.questions[session[:current_question]]

    if @number >= @length_of_quiz
      redirect_to :action => "end"
    end

    
    
    #session[:question] = @question
    #session[:answers] = @answers
  end

  def answer
    @quiz = Quiz.find(params[:id])
    @length_of_quiz = @quiz.questions.length
    @number = session[:current_question]
    @current_question = @quiz.questions[session[:current_question]]
    
    if params = @current_question.answer.correct == 1
      session[:correct_answers] += 1
    end

    session[:current_question] += 1
    redirect_to :action => "question", :id => @quiz.id
    binding.pry
  end

  def end
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

  def quiz_params
    params.require(:quiz).permit(:quiz_name, :description, :category_id)
  end
end