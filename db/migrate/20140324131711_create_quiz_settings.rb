class CreateQuizSettings < ActiveRecord::Migration
  def change
    create_table :quiz_settings do |t|
      t.integer :question_id
      t.integer :quiz_id
    end
  end
end
