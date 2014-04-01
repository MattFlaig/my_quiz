class QuizzesController < ApplicationController
  require 'pry'

  before_action :set_categories 
  before_action :require_login , except: [:index, :start, :question, :answer, :score]

  def index
    @quizzes = Quiz.all
  end

  def new
    @quiz = current_user.quizzes.build
    @category = Category.find_by_id(params[:category])
    #@questions = Question.all
  end

  def show
    @quiz = Quiz.find(params[:id])
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
    @quiz = current_user.quizzes.find(params[:id])
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
    @quiz = Quiz.find(params[:id])
    unless @quiz.questions.empty? 
      session[:current_question] = 0
      session[:correct_answers] = 0
      redirect_to :action => "question", :id => @quiz.id
    else
      flash[:danger] = "Please create some questions for this quiz first!"
      redirect_to root_path
    end
  end

  def question
    prepare_quiz
    unless @answers == nil
      @answers = @current_question.answers
      session[:current_question] = @number
    else
      flash[:danger] = "Please create some answers for this question first!"
      redirect_to root_path
    end
    
  end

  def answer
    prepare_quiz
    @answer_choice = Answer.find_by_id(params[:answer])
    if @answer_choice.correct == 1
      flash[:notice] = "Congratulations, this answer was correct!"
      session[:correct_answers] += 1
    else
      flash[:danger] = "Sorry, your answer was wrong!"
    end
    session[:current_question] += 1
  end

  def score
    prepare_quiz
    @score = session[:correct_answers]
    @percent = ((@score.to_f / @length_of_quiz.to_f) * 100).to_i
  end

  
  private

  def prepare_quiz
    @quiz = Quiz.find(params[:id])
    @length_of_quiz = @quiz.questions.length
    @number = session[:current_question]
    @current_question = @quiz.questions[session[:current_question]]
  end

  def set_variables_for_create
    @category = Category.find_by_id(params[:category_id])
    @quiz = current_user.quizzes.build(params[:quiz])
    @quiz.category = @category
    #@questions = @category.questions
    #@quiz.questions = @questions.find_by_id(params[:questions])
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

  # def quiz_params
  #   params.require(:quiz).permit(:quiz_name, :description, :category_id, :question_ids)
  # end
end