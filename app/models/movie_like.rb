class MovieLike < ApplicationRecord
  belongs_to :movie
  belongs_to :user

  # ★同じユーザーが同じ動画に2回以上いいねできないようにする
  validates_uniqueness_of :movie_id, scope: :user_id
end
