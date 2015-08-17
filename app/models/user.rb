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

  # NOTE: followers and followees methods should optimally also be cleaned up with detangling of User and Following models in the future
  def followers
#TODO! REFACTOR: this is an N+1 query situation that needs eager loading to fix it;
# however, finding optimal way via with AR in rails 4 was slow and ambigiuous, so temp-only doing N+1 way to make it work (n is still small for now, at least, anyway)
    follower_ids = Following.where(:followee_id => self.id).order(:follower_id).pluck(:follower_id)
    followers = []
    follower_ids.each do |follower_id|
      followers << User.find(follower_id)
    end
    followers
  end

  # NOTE: this should optimally also be cleaned up with detangling of User and Following models in the future
  def followees
#TODO! REFACTOR: this is an N+1 query situation that needs eager loading to fix it;
    followee_ids = Following.where(:follower_id => self.id).order(:followee_id).pluck(:followee_id)
    followees = []
    followee_ids.each do |followee_id|
      followees << User.find(followee_id)
    end
    followees
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
