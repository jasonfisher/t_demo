require 'spec_helper'
require 'factory_girl'

RSpec.describe User, type: :model do

  before(:each) do
    User.delete_all
    @user_1 = FactoryGirl.build(:user)

  end

#TODO: how to test user creation with confirm_password when that is handled within the devise gem?

  context "when creating a user" do

    it "fails validation with no username" do
     expect(User.create(:username => nil).errors[:username].size).to eq(1)
    end

    it "fails validation with no email" do
      expect(User.create(:email => nil).errors[:email].size).to eq(1)
    end

    it "fails validation with no password" do
      expect(User.create(:password => nil).errors[:password].size).to eq(1)
    end


    it "should validate uniqueness of usernames" do
      @user_1.save!

    end

    it "should validate uniqueness of emails" do

    end

    it "should validate format of email address" do

    end

    it "should validate presence of password"

    it "should validate password and confirm password match"
  end

end
