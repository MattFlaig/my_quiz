class AddSlugToQuizzes < ActiveRecord::Migration
  def change
    add_column :quizzes, :slug, :string
  end
end
