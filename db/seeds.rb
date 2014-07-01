# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

users = User.create([{username: "Bob", email: "bob@bob.com", password: "password"},{username: "Gina", email: "gina@gina.com", password: "gina"}])
categories = Category.create([{category_name: "Number Sequences"}, {category_name: "Programming"}])
questions = Question.create([{question_text: "2_4_6_8_?", category_id: categories.first.id, user_id: users.first.id}, {question_text: "2_3_5_7_11_?", category_id: categories.first.id, user_id: users.first.id}])
answers = Answer.create([{answer_text: "10", question_id: questions.first.id, correct: 1}, {answer_text: "11", question_id: questions.first.id, correct: 0}, {answer_text: "12", question_id: questions.first.id, correct: 0},{answer_text: "14", question_id: questions.last.id, correct: 0}, {answer_text: "13", question_id: questions.last.id, correct: 1}])
quiz = Quiz.create(quiz_name: "Very easy logical sequences", description: "Please find the next element in the sequences below", category_id: categories.first.id, user_id: users.first.id, question_ids: [questions.first.id, questions.last.id])