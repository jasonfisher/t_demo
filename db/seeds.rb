
# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

  10.times do |i|
    User.create(:username => "user_#{i}", :email => "user#{i}@example.com", :password => "password")
  end

  User.all.each do |user|
    10.times do
      user.create_tweet(Faker::Lorem::sentence)
    end
  end
