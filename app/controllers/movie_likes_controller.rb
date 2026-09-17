class MovieLikesController < ApplicationController
  before_action :authenticate_user!

  def create
    @movie_like = current_user.movie_likes.create(movie_id: params[:movie_id])
    redirect_back(fallback_location: root_path)
  end

  def destroy
    @movie_like = MovieLike.find_by(movie_id: params[:movie_id], user_id: current_user.id)
    @movie_like.destroy if @movie_like.present?
    redirect_back(fallback_location: root_path)
  end
end