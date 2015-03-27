# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

emails = ["joe@example.com", "chris@example.com", "jonathan@appacademy.io",
          'conzjiang@example.com', 'mr.ruffles@chips.com']
emails.each { |email| User.create!(email: email) }


tags = ["Sports", "News", "Gossip", "Surprise!"]
tags.each { |tag| TagTopic.create!(name: tag) }


urls1 = ["espn.com", "wsj.com", "cnn.com"]
urls2 = ["tmz.com", "jacobinmag.com",
        "appacademy.io", "reddit.com"]

user = User.first
urls1.each { |url| ShortenedUrl.create_for_user_and_long_url!(user, url) }

user = User.find_by(id: 2)
urls2.each { |url| ShortenedUrl.create_for_user_and_long_url!(user, url) }


Tagging.create!(tag_id: 1, url_id: 1)
Tagging.create!(tag_id: 2, url_id: 2)
Tagging.create!(tag_id: 2, url_id: 3)
Tagging.create!(tag_id: 3, url_id: 4)
Tagging.create!(tag_id: 4, url_id: 5)
Tagging.create!(tag_id: 4, url_id: 6)
Tagging.create!(tag_id: 4, url_id: 7)
