class MovieCommentsController < ApplicationController
  before_action :authenticate_user!

  def create
    @movie = Movie.find(params[:movie_id])
    @movie_comment = @movie.movie_comments.build(movie_comment_params)
    @movie_comment.user_id = current_user.id

    if @movie_comment.save
      redirect_to movie_path(@movie), notice: "動画にコメントを投稿しました！"
    else
      redirect_to movie_path(@movie), alert: "コメントの投稿に失敗しました（空欄は投稿できません）。"
    end
  end

  def destroy
    @movie_comment = MovieComment.find(params[:id])
    if @movie_comment.user_id == current_user.id
      @movie_comment.destroy
      redirect_to movie_path(params[:movie_id]), notice: "コメントを削除しました！"
    else
      redirect_to movie_path(params[:movie_id]), alert: "他のユーザーのコメントは削除できません！"
    end
  end

  private

  def movie_comment_params
    params.require(:movie_comment).permit(:content)
  end
end