# require 'rails_helper'

class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :followings
  has_many :followees, :through => :followings, :foreign_key => :followee_id, :class_name => 'User'
  has_many :followers, :through => :followings, :foreign_key => :follower_id, :class_name => 'User'

  validates :username,
            :presence => true,
            :uniqueness => {
                :case_sensitive => false
            }
  #NOTE: gem validates_email_format_of also checks for presence, and for uniqueness (case insensitive)
  validates_email_format_of :email, :message => 'does not look like a valid email address'


  after_create :follow_self

  def follow(other_user)
    Following.create(:follower_id => self.id, :followee_id => other_user.id)
  end

  def unfollow(other_user)
    raise "can not unfollow yourself" if (self.id == other_user.id)
    following = Following.where(["follower_id = ? and followee_id = ?", self.id, other_user.id])
    raise "not following that user" if following.empty?
    following.destroy
    true
  end

  #TODO! REFACTOR: followers and followees are N+1 query situation that needs eager loading fixes;
  # (finding optimal way via with AR in rails 4 was slow and ambigiuous, so temp-only doing N+1 way to make it work (n is still small for now, at least, anyway))
  def followers
    follower_ids = Following.where(:followee_id => self.id).order(:follower_id).pluck(:follower_id)
    ret_val = []
    follower_ids.each do |follower_id|
      ret_val << User.find(follower_id)
    end
    ret_val
  end

  def followees
    followee_ids = Following.where(:follower_id => self.id).order(:followee_id).pluck(:followee_id)
    ret_val = []
    followee_ids.each do |followee_id|
      ret_val << User.find(followee_id)
    end
    ret_val
  end

  def follows?(user_id)
    following = Following.find(:follower_id => @self.id, :followee_id => user_id)
    return following ? true : false
  end

private
  def follow_self
    follow(self)
  end


end
