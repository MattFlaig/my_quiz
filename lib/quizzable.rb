module Quizzable

#take quiz actions: start, question, answer, score
  def start
    start_variables_for_quiz
    redirect_to take_quiz_path(@quiz, current_question: @quiz.questions.first, number: session[:current_question])
  end

  #question action to set up variables needed for displaying question and answers
  #dynamically in question template
  def question
    prepare_quiz

    @possible_answers = @current_question.answers
    @answer = Answer.find_by(slug: session[:already_answered][@number])
    session[:current_question] = @number
  end

  #answer action to check if answer was correct and redirecting action
  def answer
    prepare_quiz
    session[:current_question] = @number
    delete_old_answer
    save_new_answer   
    manage_redirect
  end

  #score action to count right answers and send out messages
  def score
    prepare_quiz
    compute_result
    score_feedback
  end



private

 #initiating take quiz sessions
  def start_variables_for_quiz
    @quiz = Quiz.find_by(slug: params[:id])
    session[:current_question] = 0
    session[:correct_answers] = 0
    session[:already_answered] = []
    #session[:counter] = 0
  end

  #setting variables needed for quiz actions
  def prepare_quiz
    @quiz = Quiz.find_by(slug: params[:id])
    @length_of_quiz = @quiz.questions.length
    @number = params[:number].to_i
    @current_question = Question.find_by(slug: params[:current_question])
  end

  def delete_old_answer
    session[:already_answered].each do |change_answer|
      answer = Answer.find_by(slug: change_answer)
      if answer.question_id == @current_question.id
        session[:already_answered].delete(change_answer)
      end
    end
  end

  def save_new_answer
    @answer_choice = Answer.find_by(slug: params[:answer])
    unless params[:answer].blank?
      session[:already_answered] << @answer_choice.slug
    end
    session[:already_answered].uniq!
  end

  #if last question of quiz is not reached, go to next question, 
  #otherwise redirect to score
  def manage_redirect
    if @number+1 < @length_of_quiz
      session[:current_question] += 1
      @number = session[:current_question]
      redirect_to take_quiz_path(@quiz, current_question: @quiz.questions[session[:current_question]], number: @number)
    else
      redirect_to score_path(@quiz)
    end
  end

  def compute_result
    session[:already_answered].each do |count|
      answer = Answer.find_by(slug: count)
      session[:correct_answers] += 1 if answer.correct == 1
    end
    @score = session[:correct_answers]
    @percent = ((@score.to_f / @length_of_quiz.to_f) * 100).to_i
  end

  #giving feedback for the user
  def score_feedback
    if @percent >= 80
      flash.now[:notice] = "Congratulations! This was very good!"
    elsif  @percent < 79 && @percent != 0
      flash.now[:notice] = "Not bad!"
    else
      flash.now[:danger] = "It seems you need more practice."
    end
  end


end