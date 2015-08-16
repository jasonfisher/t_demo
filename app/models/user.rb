require 'rails_helper'

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
  validates :email,
            :presence => true,
            :uniqueness => {
                :case_sensitive => false
            }
  validates_email_format_of :email, :message => 'does not look like a valid email address'

  after_create :follow_self

  def follow_self
    follow(self.id)
  end

  def follow(other_user_id)
    new_following = Following.new(:follower_id => self.id, :followee_id => other_user_id)
    logger.debug "created new following: #{new_following}"
    new_following.save!
  end

  def follows?(user_id)
    following = Following.find(:follower_id => self.id, :followee_id => user_id)
    return following ? true : false
  end





end
