class Visit < ActiveRecord::Base
  validate :visitor_id, :url_id, presence: true

  def self.record_visit!(user, shortened_url)
    raise "Incorrect user" unless user.is_a?(User)
    raise "Incorrect url" unless shortened_url.is_a?(ShortenedUrl)

    create!(visitor_id: user.id, url_id: shortened_url.id )
  end

  belongs_to(
    :visitor,
    :class_name => 'User',
    :foreign_key => :visitor_id,
    :primary_key => :id
  )

  belongs_to(
    :visited_url,
    :class_name => 'ShortenedUrl',
    :foreign_key => :url_id,
    :primary_key => :id
  )
end
