# require 'rails_helper'

class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :followings
  has_many :followeds, :through => :followings, :foreign_key => :followed_id, :class_name => 'User'
  has_many :followers, :through => :followings, :foreign_key => :follower_id, :class_name => 'User'
  has_many :tweets

  validates :username,
            :presence => true,
            :uniqueness => {
                :case_sensitive => false
            }
  #NOTE: gem validates_email_format_of also checks for presence, and for uniqueness (case insensitive)
  validates_email_format_of :email, :message => 'does not look like a valid email address'

  after_create :follow_self

  def follow(other_user)
    following = Following.create(:follower_id => self.id, :followed_id => other_user.id)
    if following.valid?
      return true
    else
      raise following.errors.messages.values.join('\n')
    end
  end

  def unfollow(other_user)
    raise "can not unfollow yourself" if (self.id == other_user.id)
#NOTE: ActiveRecord::Relation might be returning > 1 value if that was somehow created in the database but we are trusting that is not the case cuz of tweet validations
    following = Following.where(["follower_id = ? and followed_id = ?", self.id, other_user.id]).first
    raise "not following that user" if following.nil?
    Following.delete(following.id)
    true
  end

#TODO: add rspec for hastily added query methods to get num followers and num followees
  def num_followers
    follower_ids = Following.where(:followed_id => self.id).pluck(:follower_id)
    follower_ids.size
  end

  def num_followeds
    followed_ids = Following.where(:follower_id => self.id).pluck(:followed_id)
    followed_ids.size
  end

  def num_tweets
    tweet_ids = Tweet.where(:user_id => self.id).pluck(:id)
    tweet_ids.size
  end

  #TODO! REFACTOR: followers and followeds are N+1 query situation that needs eager loading fixes;
  # (finding optimal way via with AR in rails 4 was slow and ambigiuous, so temp-only doing N+1 way to make it work (n is still small for now, at least, anyway))
  def followers
    follower_ids = Following.where(:followed_id => self.id).order(:follower_id).pluck(:follower_id)
    ret_val = []
    follower_ids.each do |follower_id|
      ret_val << User.find(follower_id)
    end
    ret_val
  end

  def followeds
    followed_ids = Following.where(:follower_id => self.id).order(:followed_id).pluck(:followed_id)
    ret_val = []
    followed_ids.each do |followed_id|
      ret_val << User.find(followed_id)
    end
    ret_val
  end

  def unfollowed_users
    User.all - followeds
  end

  def create_tweet(content)
    tweet = Tweet.create(:user_id => self.id, :content => content)
    if tweet.valid?
      return tweet
    else
      raise tweet.errors.messages.values.join('\n')
    end
  end

  def get_all_tweets
    Tweet.where(:user_id => self.id).order(:user_id).to_a
  end

private
  def follow_self
    follow(self)
  end


end
