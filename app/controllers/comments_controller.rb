class CommentsController < ApplicationController
  before_action :authenticate_user!

  def create
    @tweet = Tweet.find(params[:tweet_id])
    @comment = @tweet.comments.build(comment_params)
    @comment.user_id = current_user.id

    if @comment.save
      redirect_to tweet_path(@tweet), notice: "コメントを投稿しました！"
    else
      redirect_to tweet_path(@tweet), alert: "コメントの投稿に失敗しました（空欄は投稿できません）。"
    end
  end

  def destroy
    @comment = Comment.find(params[:id])
    if @comment.user_id == current_user.id
      @comment.destroy
      redirect_to tweet_path(params[:tweet_id]), notice: "コメントを削除しました！"
    else
      redirect_to tweet_path(params[:tweet_id]), alert: "他のユーザーのコメントは削除できません！"
    end
  end

  private

  def comment_params
    params.require(:comment).permit(:content)
  end
end
