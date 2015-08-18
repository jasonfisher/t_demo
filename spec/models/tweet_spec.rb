require 'rails_helper'

RSpec.describe Tweet, type: :model do
  # before(:each) do
  #   Tweet.delete_all
  #   @tweet = FactoryGirl.build(:tweet)
  # end

  context "when creating a user" do

    it "should fail validation with no user_id" do
      expect(Tweet.create(:user_id => nil).errors[:user_id]).to eq(["can't be blank"])
    end

    it "should fail validation with no content" do
      expect(Tweet.create(:content => nil).errors[:content]).to eq(["can't be blank"])
    end

    it "should fail validation if content > Tweet::MAX_TWEET_LENGTH characters" do
      long_string = "******************************************************************************************************************************************************"
      expect(long_string.length).to eq(150)
      expect(Tweet.create(:content => long_string).errors[:content]).to eq(["tweets can not be more than 144 characters long"])
    end


  end
end
