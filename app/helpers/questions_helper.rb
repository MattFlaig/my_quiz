module QuestionsHelper
  def back_to_questions_list
    content_tag(:p,
      link_to("Back to list", questions_path),
      class: "btn btn-large btn-info")
  end
end