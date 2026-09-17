class CreateMovieComments < ActiveRecord::Migration[7.2]
  def change
    create_table :movie_comments do |t|
      t.text :content
      t.references :user, null: false, foreign_key: true
      t.references :movie, null: false, foreign_key: true

      t.timestamps
    end
  end
end
