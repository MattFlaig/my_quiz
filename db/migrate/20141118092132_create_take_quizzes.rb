class CreateTakeQuizzes < ActiveRecord::Migration
  def change
    create_table :take_quizzes do |t|
    	t.integer :quiz_id
    	t.integer :user_id
    	t.string :score

    	t.timestamps
    end
  end
end
