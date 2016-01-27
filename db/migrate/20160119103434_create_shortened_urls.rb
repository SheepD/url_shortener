class CreateShortenedUrls < ActiveRecord::Migration
  def change
    create_table :shortened_urls do |t|
      t.string :original_url
      t.string :slug
      t.timestamps null: false
    end
  end
end
