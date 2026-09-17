class MoviesController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :ensure_correct_user, only: [:edit, :update, :destroy]

  def index
    if params[:search].present?
      # 🔍 キーワード検索：曲名（movietitle）または見どころ（point）にヒットするものを抽出
      keyword = "%#{params[:search]}%"
      @movies = Movie.where("movietitle LIKE ? OR point LIKE ?", keyword, keyword).order(created_at: :desc)
    else
      @movies = Movie.order(created_at: :desc)
    end
  end

  def show
    @movie = Movie.find(params[:id])
  end

  def new
    @movie = Movie.new
  end

  def create
    @movie = current_user.movies.build(movie_params)
    if @movie.save
      redirect_to movies_path, notice: "演奏動画を投稿しました！"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @movie = Movie.find(params[:id])
  end

  def update
    @movie = Movie.find(params[:id])
    if @movie.update(movie_params)
      redirect_to movie_path(@movie.id), notice: "動画情報を更新しました！"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    redirect_to movies_path, notice: "動画を削除しました！"
  end

  private

  def movie_params
    params.require(:movie).permit(:movietitle, :point, :link)
  end

  # 🔒 本人確認ガード：投稿者と現在のユーザーが一致しなければトップへ弾く
  def ensure_correct_user
    @movie = Movie.find_by(id: params[:id])
    if @movie.nil? || @movie.user_id != current_user.id
      redirect_to root_path, alert: "他のユーザーの動画は編集・削除できません！"
    end
  end
end