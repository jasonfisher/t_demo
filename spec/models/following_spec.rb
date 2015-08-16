require 'rails_helper'
require 'spec_helper'
require 'factory_girl'

RSpec.describe Following, type: :model do

    context "when creating a Following" do

      it "fails validation with no follower_id" do
        expect(Following.create(:follower_id => nil).errors[:follower_id].size).to eq(1)
        expect(Following.create(:follower_id => nil).errors[:follower_id]).to include("can't be blank")
      end

      it "fails validation with no followee_id" do
        expect(Following.create(:followee_id => nil).errors[:followee_id].size).to eq(1)
        expect(Following.create(:followee_id => nil).errors[:followee_id]).to include("can't be blank")
      end

      it "should not allow duplicate folloowings" do
        user_1 = FactoryGirl.create(:user)
        user_2 = FactoryGirl.create(:user)
        Following.create(:followee_id => user_1.id, :follower_id => user_2.id)
        expect(Following.create(:followee_id => user_1.id, :follower_id => user_2.id).errors[:follower_id]).to include("already following that user")
      end


      # it "validates uniqueness of usernames" do
      #   @user_1.save!
      #   expect(User.create(:username => @user_1.username).errors[:username].size).to eq(1)
      #   expect(User.create(:username => @user_1.username).errors[:username]).to include("has already been taken")
      # end
      #
      # it "fails validation with no password" do
      #   expect(User.create(:password => nil).errors[:password].size).to eq(1)
      #   expect(User.create(:password => nil).errors[:password]).to include("can't be blank")
      # end
      #
      # it "fails validation with no email" do
      #   expect(User.create(:email => nil).errors[:email].size).to eq(2)
      #   expect(User.create(:email => nil).errors[:email]).to include("can't be blank")
      #   expect(User.create(:email => nil).errors[:email]).to include("does not look like a valid email address")
      # end
      #
      # it "should validate format of email address" do
      #   expect(User.create(:email => "invalidaddress@invalid").errors[:email].size).to eq(2)
      #   expect(User.create(:email => "invalidaddress@invalid").errors[:email]).to include("is invalid") #would prefer only 1 error message but this is existing behavior
      #   expect(User.create(:email => "invalidaddress@invalid").errors[:email]).to include("does not look like a valid email address")
      # end
      #
      # it "should validate uniqueness of email address" do
      #   @user_1.save!
      #   expect(User.create(:email => @user_1.email).errors[:email].size).to eq(1)
      #   expect(User.create(:email => @user_1.email).errors[:email]).to include("has already been taken")
      # end
      #
      # it "should be case-insensitive when validating uniqueness of email address" do
      #   @user_1.save!
      #   expect(User.create(:email => @user_1.email.upcase).errors[:email].size).to eq(1)
      #   expect(User.create(:email => @user_1.email.upcase).errors[:email]).to include("has already been taken")
      # end

    end

  end
