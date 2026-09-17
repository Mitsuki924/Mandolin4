class AddAreaToTweets < ActiveRecord::Migration[7.2]
  def change
    add_column :tweets, :area, :string
  end
end
