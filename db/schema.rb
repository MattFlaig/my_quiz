# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20141118092132) do

  create_table "answers", force: true do |t|
    t.string   "answer_text"
    t.integer  "question_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "correct"
    t.string   "slug"
  end

  create_table "categories", force: true do |t|
    t.string   "category_name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "questions", force: true do |t|
    t.string   "question_text"
    t.integer  "category_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
    t.string   "slug"
  end

  create_table "quiz_settings", force: true do |t|
    t.integer "question_id"
    t.integer "quiz_id"
  end

  create_table "quizzes", force: true do |t|
    t.string   "quiz_name"
    t.string   "description"
    t.integer  "category_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "slug"
  end

  create_table "reviews", force: true do |t|
    t.integer  "user_id"
    t.integer  "quiz_id"
    t.integer  "rating"
    t.text     "content"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "take_quizzes", force: true do |t|
    t.integer  "quiz_id"
    t.integer  "user_id"
    t.string   "score"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: true do |t|
    t.string   "username"
    t.string   "email"
    t.string   "password_digest"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "slug"
  end

end
