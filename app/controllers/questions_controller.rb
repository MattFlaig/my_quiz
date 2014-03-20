class QuestionsController < ApplicationController


  def index
    @questions = Question.all
    @categories = Category.all
  end
end