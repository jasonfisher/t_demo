
# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

  NUM_USERS = 10

  #create some users
  NUM_USERS.times do |i|
    User.create(:username => "user#{i}", :email => "user#{i}@example.com", :password => "pppppppp")
  end

  #create some tweets by those users
  User.all.each do |user|
    Random.rand(NUM_USERS).times do
      user.create_tweet(Faker::Lorem::sentence)
    end
  end

  #have each user follow some random # of other users
  all_users = User.all
  all_users.each do |user|
    rand_num_times = Random.rand(NUM_USERS)
    STDERR.puts "user #{user.username} will try to follow #{rand_num_times} other users..."
    rand_num_times.times do |i|
      begin
        user.follow(all_users[i-1])
      rescue RuntimeError => re
        #user tried to friend themselves
        # STDERR.puts("oops, can't follow yourself...")
      end
    end
  end

  STDERR.puts("create: #{User.count} users, #{Following.count} followings, #{Tweet.count} tweets" )
