class Movie < ApplicationRecord
  belongs_to :user

  has_many :movie_comments, dependent: :destroy
  has_many :movie_likes, dependent: :destroy
  has_many :liked_users, through: :movie_likes, source: :user
end