class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  # 投稿した演奏会と動画
  has_many :tweets, dependent: :destroy
  has_many :movies, dependent: :destroy

  # コメント関連
  has_many :comments, dependent: :destroy
  has_many :movie_comments, dependent: :destroy

  # 演奏会への「気になる！」関連
  has_many :likes, dependent: :destroy
  has_many :liked_tweets, through: :likes, source: :tweet

  # 動画への「気になる！」関連
  has_many :movie_likes, dependent: :destroy
  has_many :liked_movies, through: :movie_likes, source: :movie

  # 判定メソッド
  def already_liked?(tweet)
    self.likes.exists?(tweet_id: tweet.id)
  end

  def already_movie_liked?(movie)
    self.movie_likes.exists?(movie_id: movie.id)
  end
end