class HomesController < ApplicationController
  def top
    # 📅 これから開催される直近の演奏会を最大3件取得
    @upcoming_tweets = Tweet.where("date >= ? OR date IS NULL", Date.today).order(date: :asc).limit(3)

    # 🎬 新着の演奏動画を最大3件取得
    @recent_movies = Movie.order(created_at: :desc).limit(3)
  end

  def about
  end
end