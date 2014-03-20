# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

categories = Category.create([{category_name: "Number Sequences"}, {category_name: "Programming"}])
questions = Question.create([{question_text: "2_4_6_8_?", category_id: categories.first.id}, {question_text: "2_3_5_7_11_?", category_id: categories.first.id}])
answers = Answer.create([{answer_text: "10", question_id: questions.first.id}, {answer_text: "11", question_id: questions.first.id}, {answer_text: "12", question_id: questions.first.id}])