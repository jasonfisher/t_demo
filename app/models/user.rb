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

  def follow_self
    follow(self)
  end

  def follow(other_user)
    Following.create(:follower_id => self.id, :followee_id => other_user.id)
  end

  # NOTE: this should optimally also be cleaned up with detangling of User and Following models in the future

  def followees

#TODO! REFACTOR: this is an N+1 query situation that needs eager loading to fix it;
# however, finding optimal way via with AR in rails 4 was slow and ambigiuous, so temp-only doing N+1 way to make it work (n is still small for now, at least, anyway)

    followee_ids = Following.where(:follower_id => self.id).pluck(:followee_id)
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





end
