require 'spec_helper'
require 'factory_girl'

RSpec.describe User, type: :model do

  before(:each) do
    User.delete_all
    @user_1 = FactoryGirl.build(:user)

  end

#TODO: how to test user creation with confirm_password when that is handled within the devise gem?

  context "when creating a user" do

    Following.delete_all

    it "fails validation with no username" do
     expect(User.create(:username => nil).errors[:username].size).to eq(1)
     expect(User.create(:username => nil).errors[:username]).to include("can't be blank")
    end

    it "validates uniqueness of usernames" do
      @user_1.save!
      expect(User.create(:username => @user_1.username).errors[:username].size).to eq(1)
      expect(User.create(:username => @user_1.username).errors[:username]).to include("has already been taken")
    end

    it "fails validation with no password" do
      expect(User.create(:password => nil).errors[:password].size).to eq(1)
      expect(User.create(:password => nil).errors[:password]).to include("can't be blank")
    end

    it "fails validation with no email" do
      expect(User.create(:email => nil).errors[:email].size).to eq(2)
      expect(User.create(:email => nil).errors[:email]).to include("can't be blank")
      expect(User.create(:email => nil).errors[:email]).to include("does not look like a valid email address")
    end

    it "should validate format of email address" do
      expect(User.create(:email => "invalidaddress@invalid").errors[:email].size).to eq(2)
      expect(User.create(:email => "invalidaddress@invalid").errors[:email]).to include("is invalid") #would prefer only 1 error message but this is existing behavior
      expect(User.create(:email => "invalidaddress@invalid").errors[:email]).to include("does not look like a valid email address")
    end

    it "should validate uniqueness of email address" do
      @user_1.save!
      expect(User.create(:email => @user_1.email).errors[:email].size).to eq(1)
      expect(User.create(:email => @user_1.email).errors[:email]).to include("has already been taken")
    end

    it "should be case-insensitive when validating uniqueness of email address" do
      @user_1.save!
      expect(User.create(:email => @user_1.email.upcase).errors[:email].size).to eq(1)
      expect(User.create(:email => @user_1.email.upcase).errors[:email]).to include("has already been taken")
    end

#surely there is a more elegant way to test this but I think suffices to prove the point
    it "should automatically create a following of itself upon creation" do
      expect(Following.count).to eq(0)
      @user_1.save!
      expect(Following.count).to eq(1)
      expect(Following.first.followee_id).to eq(@user_1.id)
      expect(Following.first.follower_id).to eq(@user_1.id)
    end

  #   it "should make the user its own and only follower" do
  #     expect(@follower.followers).to eq(@follower)
  #   end
  #
  #   it "should make the user its own and only followee" do
  #     expect(@follower.followees).to eq(@follower)
  #
  end

  context "when following" do
    before (:each) do
      @follower = FactoryGirl.create(:user)
      @followee = FactoryGirl.create(:user)
    end

    it "should create and return a new Following" do
      #NOTE: refactor to better AR usage here
      expect(@follower.follow(@followee)).to eq(Following.where(["follower_id = ? and followee_id = ?", @follower.id, @followee.id]).first)
    end


#NOTE: with intertwined models what is the best way to handle this? (error creation at Following level bubbled up through follow method)
    it "should validate uniqueness of follow relationship" do
      @follower.follow(@followee)
      expect(@follower.follow(@followee).errors[:follower_id]).to include("already following that user")
    end

    # see NOTES at bottom of page about ActiveModel::Relation vs [User] types
    # NOTE: this is a test of the followees method -- refactor elsewhere? (what is best practice here?)
    it "should add the new User to followees return value" do
      expect(@follower.followees.size).to eq(1) #self only
      @follower.follow(@followee)
      expect(@follower.followees.size).to eq(2) #self and new followee
      expect(@follower.followees).to eq(User.find([@follower.id, @followee.id]))
    end

# NOTE: this is a test of the followers method -- refactor elsewhere? (what is best practice here?)
#     it "should add the User to the followee's follower list" do
#
#     end



    #NOTE: don't create and test this until we have need for it in the code!
    # it "should return true from follows? method" do
    #
    # end

  end

  context "when un-following" do
    it "should not let a User un-follow themselves"

    it "should validate the Following already exists"

    it "should return false from follows? method"
  end

end

#  NOTES ABOUT ACTIVERELATION VS AR OBJECT ISSUES
#  FOR @user.followees continually getting ActiveRelation instead of array of user objects, e.g. rspec error message below
#   unclear how to change either one to the other; even adding load explicitly into followee method of User object failed to produce actual User objects into the return value
# expected: [#<User id: 564, email: "username4@castlighthealth.com", encrypted_password: "$2a$04$2k1IX/LS6NS0GG0ZZoovSu4IlfBpWWeYrkY8TqxPu3Z...", reset_password_token: nil, reset_password_sent_at: nil, remember_created_at: nil, sign_in_count: 0, current_sign_in_at: nil, last_sign_in_at: nil, current_sign_in_ip: nil, last_sign_in_ip: nil, created_at: "2015-08-17 17:31:54", updated_at: "2015-08-17 17:31:54", username: "username4">, #<User id: 565, email: "username5@castlighthealth.com", encrypted_password: "$2a$04$HDitl/fPvPIV/txKx1mgvO/CEYy9i6V3DsPX95R8hEu...", reset_password_token: nil, reset_password_sent_at: nil, remember_created_at: nil, sign_in_count: 0, current_sign_in_at: nil, last_sign_in_at: nil, current_sign_in_ip: nil, last_sign_in_ip: nil, created_at: "2015-08-17 17:31:54", updated_at: "2015-08-17 17:31:54", username: "username5">]
#     got: [#<ActiveRecord::Relation [#<User id: 564, email: "username4@castlighthealth.com", encrypted_password: "$2a$04$2k1IX/LS6NS0GG0ZZoovSu4IlfBpWWeYrkY8TqxPu3Z...", reset_password_token: nil, reset_password_sent_at: nil, remember_created_at: nil, sign_in_count: 0, current_sign_in_at: nil, last_sign_in_at: nil, current_sign_in_ip: nil, last_sign_in_ip: nil, created_at: "2015-08-17 17:31:54", updated_at: "2015-08-17 17:31:54", username: "username4">]>, #<ActiveRecord::Relation [#<User id: 565, email: "username5@castlighthealth.com", encrypted_password: "$2a$04$HDitl/fPvPIV/txKx1mgvO/CEYy9i6V3DsPX95R8hEu...", reset_password_token: nil, reset_password_sent_at: nil, remember_created_at: nil, sign_in_count: 0, current_sign_in_at: nil, last_sign_in_at: nil, current_sign_in_ip: nil, last_sign_in_ip: nil, created_at: "2015-08-17 17:31:54", updated_at: "2015-08-17 17:31:54", username: "username5">]>]

# SOLUTION: ultimately the fixit was changing a line in user.followees from .where(:id => X) to .find(x), which then returned a User object, not a relation -- I need to read up further on relations