class Tweet < ActiveRecord::Base
  belongs_to :user

  MAX_TWEET_LENGTH = 144

  validates :user_id, :presence => true
  validates :content, :presence => true
  validates_length_of :content, :maximum => MAX_TWEET_LENGTH

end
