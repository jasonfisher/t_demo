require 'rails_helper'

RSpec.describe Tweet, type: :model do
  # before(:each) do
  #   Tweet.delete_all
  #   @tweet = build(:tweet)
  # end

  context "when creating a tweet" do

    context "with invalid parameters" do
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

#TODO: this section is awkward and/or unnecessary
    context "with valid parameters" do
      it "should return the creating User" do
        @tweet = create(:tweet)
        expect(@tweet.user.class.name).to eq("User")
      end

      it "should return its content" do
        @user = create(:user)
        content_string = "here is some content!"
        tweet = Tweet.create(:user_id => @user.id, :content => content_string)
        expect(tweet.content).to eq(content_string)
      end

      it "should return its created_at time" do
        tweet = create(:tweet)
        expect(tweet.created_at.class.name).to eq("Time")
      end

    end

  end

  context "when deleting a tweet" do
    it "should remove the tweet from the database"

    it "should remove the tweet from the list returned by get_tweets"
  end

  context "update is called on a tweet" do
    it "should not allow the user_id to be changed"

    it "should not allow the created_at time to be changed"

    it "should not allow the content to be changed"

  end
end
