class QuizzesController < ApplicationController
  require 'pry'

  #to be able to create a quiz with preselected category (Dropdownmenu "New Quiz")
  before_action :set_categories 

  #method to require current user
  before_action :require_login , except: [:index, :start, :question, :answer, :score, :survey]
  
  #not allow other users to edit or destroy your own quiz
  before_action :restrict_access, only: [:edit, :update, :destroy]
  
  #set quiz for actions to be able to use slugs
  before_action :set_quiz, only: [:show, :edit, :update, :destroy]

  def index
    @quizzes = Quiz.all
  end

  def new
    @quiz = Quiz.new
    @category = Category.find_by_id(params[:category])
    check_for_answers(@category.questions) unless @category.questions.empty?
  end

  def show
    @reviews = @quiz.reviews
  end

  def create
    set_variables_for_create
    check_for_answers(@category.questions) unless @category.questions.empty?
 
    if @quiz.save
      flash[:notice] = "Your quiz was succesfully created!"
      redirect_to quizzes_path
    else
      render 'new'
    end
  end

  def edit
    @category = @quiz.category
    check_for_answers(@category.questions) unless @category.questions.empty?
  end

  def update
    @category = @quiz.category
    check_for_answers(@category.questions) unless @category.questions.empty?
    if @quiz.update_attributes(params[:quiz])
      flash[:notice] = "Your quiz was updated!"
      redirect_to quizzes_path
    else
      render 'edit'
    end
  end

  def destroy
    @quiz.destroy
    flash[:notice] = "Your quiz has been deleted!"
    redirect_to quizzes_path
  end

  #help action left empty because template is rendered automatically 
  def help
  end

  private

  #method to check if a question has enough answers, otherwise
  #it won't be available in create quiz action
  def check_for_answers(questions)
    @possible_questions = []
    questions.each do |question| 
      unless question.answers.length < 2 
        @possible_questions << question 
      end 
      @possible_questions
    end 
  end

  def set_quiz
    @quiz = Quiz.find_by(slug: params[:id])
  end

  #setting variables and associating quiz params with user_id
  def set_variables_for_create
    @category = Category.find_by_id(params[:category_id])
    @quiz = Quiz.new(params[:quiz].merge!(:user_id => current_user.id))
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
    @quiz = Quiz.find_by(slug: params[:id])
    if current_user != @quiz.user
      flash[:danger] = "You are not allowed to do that!"
      redirect_to quizzes_path
    end
  end

end