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
      flash.now[:notice] = "Your quiz was succesfully created!"
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
      flash.now[:notice] = "Your quiz was updated!"
      redirect_to quizzes_path
    else
      render 'edit'
    end
  end

  def destroy
    @quiz = current_user.quizzes.find(params[:id])
    @quiz.destroy
    flash.now[:notice] = "Your quiz has been deleted!"
    redirect_to quizzes_path
  end

  def start
    @quiz = Quiz.find(params[:id])
    session[:current_question] = 0
    session[:correct_answers] = 0
    session[:wrong_answers] = 0
    #session[:already_answered] = []
    redirect_to :action => "question", :id => @quiz.id
  end

  def question
    @quiz = Quiz.find(params[:id])

    # if params[:current_question]
    #  @length_of_quiz = @quiz.questions.length
    #  go_back_params = params[:current_question].to_i
    #  @current_question = @quiz.questions[go_back_params]
    #  @number = go_back_params
    #  @answers = @quiz.questions[go_back_params].answers
    #  @answer = Answer.find_by_id(session[:already_answered])
    # else
      prepare_quiz
      @answers = @current_question.answers
    #end
    session[:current_question] = @number
    #binding.pry
  end

  def answer
    @quiz = Quiz.find(params[:id])
    prepare_quiz
    @answer_choice = Answer.find_by_id(params[:answer])
    if @answer_choice && @answer_choice.correct == 1
      session[:correct_answers] += 1
    else  
      session[:wrong_answers] += 1
    end
    #session[:already_answered] << params[:answer]
    #binding.pry
    
    if @number+1 < @length_of_quiz
      session[:current_question] += 1
      redirect_to :action => "question", :id => @quiz.id
    else
      redirect_to :action => "score", :id => @quiz.id
    end
  end

  def score
    @quiz = Quiz.find(params[:id])
    prepare_quiz
    @score = session[:correct_answers]
    @percent = ((@score.to_f / @length_of_quiz.to_f) * 100).to_i
  end

  
  private

  def prepare_quiz
    #@quiz = Quiz.find(params[:id])
    @length_of_quiz = @quiz.questions.length
    @number = session[:current_question]
    @current_question = @quiz.questions[session[:current_question]]
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