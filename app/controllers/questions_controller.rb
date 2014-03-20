class QuestionsController < ApplicationController

  def index
    @questions = Question.all
    @categories = Category.all
  end

  def new
    @question = Question.new
  end

  def create
  end
end