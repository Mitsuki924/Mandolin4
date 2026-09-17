class AddWebsiteUrlToTweets < ActiveRecord::Migration[7.2]
  def change
    add_column :tweets, :website_url, :string
  end
end
