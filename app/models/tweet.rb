class Tweet < ActiveRecord::Base
  belongs_to :user

  MAX_TWEET_LENGTH = 144

  validates :user_id, :presence => true
  validates :content, :presence => true
  validates_length_of :content, :maximum => MAX_TWEET_LENGTH

#TODO: REFACTOR/FIX -- surely AR has a way to do this elegantly but I couldn't find it and used this hack
  before_update :disallow_updates

  def disallow_updates
    raise "tweets can not be updated"
  end
end
