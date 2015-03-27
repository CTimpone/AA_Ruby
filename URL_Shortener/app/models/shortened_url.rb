class ShortenedUrl < ActiveRecord::Base

  validates :submitter_id, :long_url, :short_url,
    :presence => true

  validates :short_url, :uniqueness => true
  validates :long_url, :length => {maximum: 1024}
  validate :cannot_store_more_than_five_urls_in_one_minute

  def self.random_code
    loop do
      code = SecureRandom::urlsafe_base64
      return code unless self.exists?(:short_url => code)
    end
  end

  def self.create_for_user_and_long_url!(user, long_url)
    raise 'Not a user object.' unless user.is_a?(User)
    self.create!(:long_url => long_url,
                  :short_url => random_code,
                  :submitter_id => user.id)
  end

  belongs_to(
  :submitter,
  :class_name => 'User',
  :foreign_key => :submitter_id,
  :primary_key => :id
  )

  has_many(
  :visits,
  :class_name => 'Visit',
  :foreign_key => :url_id,
  :primary_key => :id
  )

  has_many(
  :taggings,
  :class_name => 'Tagging',
  :foreign_key => :url_id,
  :primary_key => :id
  )

  has_many :tag_topics, through: :taggings, source: :tag_topic
  has_many :visitors, Proc.new { distinct }, through: :visits, source: :visitor

  def num_clicks
    Visit.where(url_id: id).count
  end

  def num_uniques
    self.visitors.count
    #Visit.where(url_id: id).distinct.count(:visitor_id)
  end

  def num_recent_uniques
    self.visitors.where(
      "visits.updated_at > :time", {time: 10.minutes.ago}).count(:visitor_id)
    # Visit.where(
    # "url_id = :id AND updated_at > :time",
    # {id: id, time: 10.minutes.ago}).distinct.count(:visitor_id)
  end

  private
  def cannot_store_more_than_five_urls_in_one_minute
    count = ShortenedUrl.where('submitter_id = :id AND created_at > :time',
    {id: submitter_id, time: 1.minute.ago} ).count
    if count > 4
      errors[:submitter_id] << "can't submit more than 5 urls in a min"
    end
  end
end
