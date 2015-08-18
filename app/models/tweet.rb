class Tweet < ActiveRecord::Base
  belongs_to :user

  validates :user_id, :presence => true
  validates :content, :presence => true
  validates_length_of :content, :maximum => 144, :message => "tweets can not be more than 144 characters long"

end
