class TweetsController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create, :edit, :update, :destroy]

  def index
    @tab = params[:tab] || "upcoming"
    @area = params[:area]

    # ベースとなるクエリ
    base_tweets = Tweet.all

    # キーワード検索
    if params[:search].present?
      search_word = "%#{params[:search]}%"
      base_tweets = base_tweets.where("title LIKE ? OR name LIKE ? OR program LIKE ? OR place LIKE ?", search_word, search_word, search_word, search_word)
    end

    # エリア（地域）絞り込み
    if @area.present?
      base_tweets = base_tweets.where(area: @area)
    end

    # タブ切り替え（これからの演奏会 / 過去の演奏会）
    today = Date.today
    @upcoming_count = base_tweets.where("date >= ?", today).count
    @past_count = base_tweets.where("date < ?", today).count

    if @tab == "past"
      @tweets = base_tweets.where("date < ?", today).order(date: :desc)
    else
      @tweets = base_tweets.where("date >= ?", today).order(date: :asc)
    end
  end

  def show
    @tweet = Tweet.find(params[:id])
  end

  def new
    @tweet = Tweet.new
  end

  def create
    @tweet = Tweet.new(tweet_params.except(:pamphlets))
    @tweet.user_id = current_user.id

    if tweet_params[:pamphlets].present?
      @tweet.pamphlets.attach(tweet_params[:pamphlets])
    end

    if @tweet.save
      redirect_to tweets_path, notice: "演奏会情報を投稿しました！"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @tweet = Tweet.find(params[:id])
    if @tweet.user_id != current_user.id
      redirect_to tweet_path(@tweet.id), alert: "他のユーザーの演奏会は編集できません。"
    end
  end

  def update
    @tweet = Tweet.find(params[:id])
    if @tweet.user_id != current_user.id
      redirect_to tweet_path(@tweet.id), alert: "他のユーザーの演奏会は編集できません。"
      return
    end

    t_params = tweet_params

    # 新しい画像が選択されている場合は追加添付
    if t_params[:pamphlets].present?
      @tweet.pamphlets.attach(t_params[:pamphlets])
    end

    if @tweet.update(t_params.except(:pamphlets))
      redirect_to tweet_path(@tweet.id), notice: "演奏会情報を更新しました！"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    tweet = Tweet.find(params[:id])
    if tweet.user_id == current_user.id
      tweet.destroy
      redirect_to tweets_path, notice: "演奏会情報を削除しました。"
    else
      redirect_to tweets_path, alert: "権限がありません。"
    end
  end

  private

  def tweet_params
    params.require(:tweet).permit(
      :title, :name, :date, :time, :place, :price, :program, :access, :area, :website_url, pamphlets: []
    ).tap do |whitelisted|
      if whitelisted[:pamphlets].is_a?(Array)
        whitelisted[:pamphlets] = whitelisted[:pamphlets].reject(&:blank?)
      end
    end
  end
end