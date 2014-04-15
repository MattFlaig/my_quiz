def set_current_user(user=nil)
  session[:user_id] = (user || Fabricate(:user)).id
end

def check_for_answers(questions) 
  possible_questions = []
  questions.each do |question| 
    if question.answers.length >= 2 
      possible_questions << question 
    end 
  end 
  return possible_questions
end