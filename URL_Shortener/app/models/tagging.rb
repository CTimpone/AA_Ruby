class Tagging < ActiveRecord::Base

  validates :tag_id, :url_id, :presence => true

  belongs_to(
  :tag_topic,
  :class_name => 'TagTopic',
  :foreign_key => :tag_id,
  :primary_key => :id
  )

  belongs_to(
  :url,
  :class_name => 'ShortenedUrl',
  :foreign_key => :url_id,
  :primary_key => :id
  )

end
