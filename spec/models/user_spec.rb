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
        expect(@user.followees).to eq([@user])
      end

    end
  end

  context "when following another User" do
    before (:each) do
      User.delete_all
      @follower = FactoryGirl.create(:user)
      @followee = FactoryGirl.create(:user)
    end

    it "should validate uniqueness of the follow relationship" do
      @follower.follow(@followee)
      expect{ (@follower.follow(@followee)) }.to raise_error(RuntimeError, "already following that user")
    end

    it "should return true if parameters are valid" do
      expect(@follower.follow(@followee)).to be true
    end

    it "should add the new User to followees list" do
      @follower.follow(@followee)
      expect(@follower.followees).to eq(User.find([@follower.id, @followee.id]))
    end

    it "should add the User to followee's follower list" do
      @follower.follow(@followee)
      expect(@followee.followers).to eq(User.find([@followee.id, @follower.id]))
    end

    it "should return true from follows? method"  #NOTE: don't create and test this until/unless we have need for it in the code!

    end


  context "when following multiple users" do
    before (:each) do
      User.delete_all
      @follower   = create(:user)
      @followee_1 = create(:user)
      @followee_2 = create(:user)
    end

    it "should return an ordered list of all followees" do
      @follower.follow(@followee_1)
      @follower.follow(@followee_2)
      expect(@follower.followees).to eq(User.find([@follower.id, @followee_1.id, @followee_2.id])) #order
    end

    it "should return an ordered list of all followers" do
      @follower_2 = create(:user)
      @follower.follow(@followee_1)
      @follower_2.follow(@followee_1)
      expect(@followee_1.followers).to eq(User.find([@followee_1.id, @follower.id, @follower_2.id]))
    end

  end

  context "when un-following" do
    before(:each) do
      @follower = FactoryGirl.create(:user)
      @followee = FactoryGirl.create(:user)
    end

    it "should validate the Following already exists" do
      expect{ (@follower.unfollow(@followee)) }.to raise_error(RuntimeError, "not following that user")
    end

    it "should not let a User un-follow themselves" do
      expect{ (@follower.unfollow(@follower)) }.to raise_error(RuntimeError, "can not unfollow yourself")
    end

    it "should remove the follower from the followee's list of followers" do
      @follower.follow(@followee)
      expect(@followee.followers).to eq(User.find([@followee.id, @follower.id]))
      @follower.unfollow(@followee)
      expect(@followee.followers).to eq(User.find([@followee.id]))
    end

    it "should remove the followee from the follower's list of followees" do
      @follower.follow(@followee)
      expect(@followee.followers).to eq(User.find([@followee.id, @follower.id]))
      @follower.unfollow(@followee)
      expect(@follower.followees).to eq(User.find([@follower.id]))
    end

    it "should return false from follows? method"  #NOTE: don't create and test this until/unless we have need for it in the code!
  end

  it "should return a list of all unfollowed users" do
    @user = FactoryGirl.create(:user)
    @user_2 = FactoryGirl.create(:user)
    @user_3 = FactoryGirl.create(:user)
    @user_4 = FactoryGirl.create(:user)
    @user.follow(@user_2)
    expect(@user.unfollowed_users).to eq(User.find([@user_3.id, @user_4.id]))
  end

end
