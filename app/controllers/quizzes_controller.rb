class QuizzesController < ApplicationController
  before_action :set_categories 

  def index
    @quizzes = Quiz.all
  end

  def new
    @quiz = current_user.quizzes.build
    @category = Category.find_by_id(params[:category])
  end

  private

  def set_categories
    @categories = Category.all
  end
end