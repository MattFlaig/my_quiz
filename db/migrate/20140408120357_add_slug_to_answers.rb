class AddSlugToAnswers < ActiveRecord::Migration
  def change
    add_column :answers, :slug, :string
  end
end
