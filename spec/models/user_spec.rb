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
  end

  context "when following another user" do
    before (:each) do
      @follower = FactoryGirl.create(:user)
      @followee = FactoryGirl.create(:user)
    end

    it "should create and return a new Following" do
      expect(@follower.follow(@followee)).to eq(Following.where(["follower_id = ? and followee_id = ?", @follower.id, @followee.id]).first)
    end


#NOTE: with intertwined models what is the best way to handle this? (error creation at Following level bubbled up through follow method)
    it "should validate uniqueness of follow relationship" do
      @follower.follow(@followee)
      expect(@follower.follow(@followee).errors[:follower_id]).to include("already following that user")
    end

    # it "its followees should include the newly-followed User"

    # it "the followed User's followers should include the newly-following User"
    #

    #NOTE: don't create and test this until we have need for it in the code!
    # it "should return true from follows? method" do
    #
    # end

  end

  # context "when un-following another user" do
  #   it "should not let a User un-follow themself"
  #
  #   it "should validate the Following already exists"
  #
  #   it "should return false from follows? method"
  # end

end
