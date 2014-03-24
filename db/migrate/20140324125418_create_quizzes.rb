class CreateQuizzes < ActiveRecord::Migration
  def change
    create_table :quizzes do |t|
      t.string :quiz_name
      t.string :description
      t.integer :category_id
      t.integer :user_id
      
      t.timestamps
    end
  end
end
