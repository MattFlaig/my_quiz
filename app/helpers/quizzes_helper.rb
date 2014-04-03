module QuizzesHelper
  def back_to_quizzes_list
    content_tag(:p,
      link_to("Back to quizzes", quizzes_path),
      class: "btn btn-large btn-info")
  end
end