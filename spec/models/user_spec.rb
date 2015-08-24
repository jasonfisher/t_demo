require 'spec_helper'
require 'factory_girl'

RSpec.describe User, type: :model do

  it "has a valid factory" do
    user = create(:user)
    expect(user).to be_valid
  end

#TODO: how to test user creation with confirm_password when that is handled within the devise gem?

  context "when creating a user" do
    before(:each) do
      @user = build(:user)
    end

    context "with invalid parameters" do
      it "validates the presence of username" do
       expect(User.create(:username => nil).errors[:username].size).to eq(1)
       expect(User.create(:username => nil).errors[:username]).to include("can't be blank")
      end

      it "validates uniqueness of username" do
        @user.save!
        expect(User.create(:username => @user.username).errors[:username].size).to eq(1)
        expect(User.create(:username => @user.username).errors[:username]).to include("has already been taken")
      end

      it "validates the presence of password" do
        expect(User.create(:password => nil).errors[:password].size).to eq(1)
        expect(User.create(:password => nil).errors[:password]).to include("can't be blank")
      end

      it "validates the presence of email" do
        expect(User.create(:email => nil).errors[:email].size).to eq(2)
        expect(User.create(:email => nil).errors[:email]).to include("can't be blank")
        expect(User.create(:email => nil).errors[:email]).to include("does not look like a valid email address")
      end

      it "validates the format of email address" do
        expect(User.create(:email => "invalidaddress@invalid").errors[:email].size).to eq(2)
        expect(User.create(:email => "invalidaddress@invalid").errors[:email]).to include("is invalid") #would prefer only 1 error message but this is existing behavior
        expect(User.create(:email => "invalidaddress@invalid").errors[:email]).to include("does not look like a valid email address")
      end

      it "validate uniqueness of email address" do
        @user.save!
        expect(User.create(:email => @user.email).errors[:email].size).to eq(1)
        expect(User.create(:email => @user.email).errors[:email]).to include("has already been taken")
      end

      it "is case-insensitive when validating uniqueness of email address" do
        @user.save!
        expect(User.create(:email => @user.email.upcase).errors[:email].size).to eq(1)
        expect(User.create(:email => @user.email.upcase).errors[:email]).to include("has already been taken")
      end
    end

    context "with valid parameters" do
      it "makes the User follow themself" do
        @user.save!
        expect(@user.followers).to eq([@user])
      end

      it "does not make the new User follow other users" do
        user_2 = build(:user)
        @user.save!
        expect(@user.followers).to eq([@user])
      end

      it "does not make other Users follow the user" do
        user_2 = build(:user)
        @user.save!
        expect(@user.followeds).to eq([@user])
      end

    end
  end

  context "when following another User" do
    before (:each) do
      User.delete_all
      @follower = create(:user)
      @followed = create(:user)
    end

    it "should validate uniqueness of the follow relationship" do
      @follower.follow(@followed)
      expect{ (@follower.follow(@followed)) }.to raise_error(RuntimeError, "already following that user")
    end

    it "should return true if parameters are valid" do
      expect(@follower.follow(@followed)).to be true
    end

    it "should add the new User to followeds list" do
      @follower.follow(@followed)
      expect(@follower.followeds).to eq(User.find([@follower.id, @followed.id]))
    end

    it "should add the User to followed's follower list" do
      @follower.follow(@followed)
      expect(@followed.followers).to eq(User.find([@followed.id, @follower.id]))
    end
  end

  context "when following multiple users" do
    before (:each) do
      User.delete_all
      @follower   = create(:user)
      @followed_1 = create(:user)
      @followed_2 = create(:user)
    end

    it "should return an ordered list of all followeds" do
      @follower.follow(@followed_1)
      @follower.follow(@followed_2)
      expect(@follower.followeds).to eq(User.find([@follower.id, @followed_1.id, @followed_2.id])) #order
    end

    it "should return an ordered list of all followers" do
      @follower_2 = create(:user)
      @follower.follow(@followed_1)
      @follower_2.follow(@followed_1)
      expect(@followed_1.followers).to eq(User.find([@followed_1.id, @follower.id, @follower_2.id]))
    end
  end

  context "when un-following" do
    before(:each) do
      @follower = create(:user)
      @followed = create(:user)
    end

    it "should validate the Following already exists" do
      expect{ (@follower.unfollow(@followed)) }.to raise_error(RuntimeError, "not following that user")
    end

    it "should not let a User un-follow themselves" do
      expect{ (@follower.unfollow(@follower)) }.to raise_error(RuntimeError, "can not unfollow yourself")
    end

    it "should remove the follower from the followed's list of followers" do
      @follower.follow(@followed)
      expect(@followed.followers).to eq(User.find([@followed.id, @follower.id]))
      @follower.unfollow(@followed)
      expect(@followed.followers).to eq(User.find([@followed.id]))
    end

    it "should remove the followed from the follower's list of followeds" do
      @follower.follow(@followed)
      expect(@followed.followers).to eq(User.find([@followed.id, @follower.id]))
      @follower.unfollow(@followed)
      expect(@follower.followeds).to eq(User.find([@follower.id]))
    end
  end

  context "when calling unfollowed_users" do
    it "should return an ordered list of all unfollowed users" do
      @user = create(:user)
      @user_2 = create(:user)
      @user_3 = create(:user)
      @user_4 = create(:user)
      @user.follow(@user_2)
      expect(@user.unfollowed_users).to eq(User.find([@user_3.id, @user_4.id]))
    end
  end

  context "when creating tweets" do
    before(:each) do
      Tweet.delete_all
      @user = create :user
    end

#TODO/NOTE: these validations aren't very DRY since the same checks are made in the tweet model itself,
# but we want to verify that User returns a RuntimeError with the underlying validation error message

    context "with invalid parameters" do
      it "validates the presence of content" do
        expect{ (@user.create_tweet(nil).errors[:content]) }.to raise_error(RuntimeError, "can't be blank")
      end

      it "validates the minimum length of the content" do
        expect{ (@user.create_tweet("")) }.to raise_error(RuntimeError, "can't be blank")
      end

      it "validates the length of the content" do
        long_string = "******************************************************************************************************************************************************"
        expect(long_string.length).to eq(150)
        expect{ (@user.create_tweet(long_string)) }.to raise_error(RuntimeError, "is too long (maximum is 144 characters)")
      end
    end #context

    context "with valid parameters" do
      it "returns the new tweet" do
        expect(@user.create_tweet("I just tweeted!")).to eq(Tweet.where(:user_id => @user.id).last)
      end

      it "adds a tweet to the user's list of tweets" do
        expect(@user.get_all_tweets).to eq([])
        @user.create_tweet("I just tweeted!")
        expect(@user.get_all_tweets).to eq([Tweet.find_by_user_id(@user.id)])
        #TEST MULTIPLE TWEETS IN SAME TEST TO KEEP DRY
        @user.create_tweet("I just tweeted again!")
        expect(@user.get_all_tweets).to eq(Tweet.where(:user_id => @user.id).order(:user_id).to_a)
      end
    end
  end #context

  context "when deleting tweets"    #implement IFF we add delete to interface

end #whole spec
