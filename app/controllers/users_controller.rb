class UsersController < ApplicationController
  before_action :authenticate_user!

  def show
    @user = User.find(params[:id])
    
    # 自分が投稿した演奏会・動画
    @my_tweets = @user.tweets.order(date: :asc)
    @my_movies = @user.movies.order(created_at: :desc)
    
    # 自分が「気になる！」した演奏会・動画
    @liked_tweets = @user.liked_tweets.order(date: :asc)
    @liked_movies = @user.liked_movies.order(created_at: :desc)

    # 💬 自分が投稿したコメント履歴（新しい順）
    @my_comments = @user.comments.includes(:tweet).order(created_at: :desc)
    @my_movie_comments = @user.movie_comments.includes(:movie).order(created_at: :desc)
  end
end