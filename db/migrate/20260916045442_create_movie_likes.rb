class CreateMovieLikes < ActiveRecord::Migration[7.2]
  def change
    create_table :movie_likes do |t|
      t.references :movie, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
