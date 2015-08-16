class Following < ActiveRecord::Base

  belongs_to :user
  belongs_to :followee, :class_name => 'User', :foreign_key => :follower_id
  belongs_to :follower, :class_name => 'User', :foreign_key => :followee_id

  validates :follower_id, :presence => true
  validates :followee_id, :presence => true

  validates_uniqueness_of :follower_id, :scope => [:followee_id], :message => "already following that user"

end
