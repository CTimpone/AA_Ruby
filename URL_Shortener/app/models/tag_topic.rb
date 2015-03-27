class TagTopic < ActiveRecord::Base
  validates :name, presence: true, uniqueness: true


  has_many(
  :taggings,
  :class_name => 'Tagging',
  :foreign_key => :tag_id,
  :primary_key => :id
  )

  has_many :urls, through: :taggings, source: :url

  def rand_url
    self.urls.sample
  end

  def most_popular_url
    ShortenedUrl.joins(
      'JOIN taggings ON taggings.url_id = shortened_urls.id').joins(
      'JOIN tag_topics ON taggings.tag_id = tag_topics.id').joins(
      'JOIN visits ON shortened_urls.id = visits.url_id').where(
      'tag_topics.id = :id', {id: self.id}).group(
      'shortened_urls.id').order(
      'COUNT(visits.*) DESC').limit(1)
  end
end
