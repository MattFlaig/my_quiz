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

  #answer action to check if answer was changed and redirecting action
  def answer
    prepare_quiz
    session[:current_question] = @number
    delete_old_answer
    save_new_answer
 
    if params[:commit] == "Answer Survey"
      render 'quizzes/survey'
    else  
      manage_redirect
    end
  end

  #score action to count right answers and send out messages
  def score
    prepare_quiz
    compute_result
    score_feedback
  end

  def survey
    prepare_quiz
  end


private

 #initiating take quiz sessions
  def start_variables_for_quiz
    @quiz = Quiz.find_by(slug: params[:id])
    session[:current_question] = 0
    session[:correct_answers] = 0
    session[:already_answered] = []
  end

  #setting variables needed for quiz actions
  def prepare_quiz
    @quiz = Quiz.find_by(slug: params[:id])
    @length_of_quiz = @quiz.questions.length
    @number = params[:number].to_i
    @current_question = Question.find_by(slug: params[:current_question])
  end

  #when coming via go back buttons and changing already given answers
  #old answer has to be deleted
  def delete_old_answer
    session[:already_answered].each do |change_answer|
      answer = Answer.find_by(slug: change_answer)
      if answer && answer.question_id == @current_question.id
        session[:already_answered].delete(change_answer)
      end
    end
  end

  #insert new answer in session[:already_answered] at the same spot old answer was
  def save_new_answer
    @answer_choice = Answer.find_by(slug: params[:answer])
    unless params[:answer].blank?
      session[:already_answered].insert(@number, @answer_choice.slug)
    else
      session[:already_answered].insert(@number, " ")
    end
  end

  #if yellow score button was pushed, redirect to score. Else either go to next question, 
  #or, if last question is reached, also redirect to score 
  def manage_redirect
    if @number+1 < @length_of_quiz
      session[:current_question] += 1
      @number = session[:current_question]
      redirect_to take_quiz_path(@quiz, current_question: @quiz.questions[session[:current_question]], number: @number)
    else
      flash.now[:notice] = "You arrived at the end of this quiz! Please review your questions or proceed to score!"
      render 'quizzes/survey'
    end 
  end

  def compute_result
    session[:already_answered].each do |count|
      unless count == " "
        answer = Answer.find_by(slug: count)
        session[:correct_answers] += 1 if answer.correct == 1
      end
    end
    @score = session[:correct_answers]
    @percent = ((@score.to_f / @length_of_quiz.to_f) * 100).to_i
    #binding.pry
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