class ShortenedUrl < ActiveRecord::Base
  validates :original_url, presence: true
  validates :slug, presence: true, uniqueness: { message: 'Sadly, That slug has already been taken, please try a different one!' }

  def self.generate_slug
    Base64.encode64(UUIDTools::UUID.random_create)[0..8]
  end

  def self.validate_url url
    agent = Mechanize.new do |agent|
        agent.open_timeout   = 2
        agent.read_timeout   = 2
      end
    page = agent.get url
    return page.code == '200' ? true : false

  rescue => e
    false
  end
end
