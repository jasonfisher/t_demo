class Following < ActiveRecord::Base

  belongs_to :user
  belongs_to :followed, :class_name => 'User', :foreign_key => :follower_id
  belongs_to :follower, :class_name => 'User', :foreign_key => :followed_id

  validates :follower_id, :presence => true
  validates :followed_id, :presence => true

  validates_uniqueness_of :follower_id, :scope => [:followed_id], :message => "already following that user"

end
