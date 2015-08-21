require 'rails_helper'

RSpec.describe Tweet, type: :model do
  # before(:each) do
  #   Tweet.delete_all
  #   @tweet = build(:tweet)
  # end

  context "when creating a tweet" do

    context "with invalid parameters" do
      it "validates the presence of user_id" do
        expect(Tweet.create(:user_id => nil).errors[:user_id]).to eq(["can't be blank"])
      end

      it "validates the presence of content" do
        expect(Tweet.create(:content => nil).errors[:content]).to eq(["can't be blank"])
      end

      it "validates the minimum length of the content" do
        expect(Tweet.create(:content => "").errors[:content]).to eq(["can't be blank"])
      end

      it "validates the maximum length of the content" do
        long_string = "******************************************************************************************************************************************************"
        expect(long_string.length).to be > Tweet::MAX_TWEET_LENGTH
        expect(Tweet.create(:content => long_string).errors[:content]).to eq(["is too long (maximum is 144 characters)"])
      end
    end

  end

#NOTE: not sure about this whole section; while it's nice to know tweets can't be updated, did I really need this section?
  context "if update is called on a tweet" do
    before (:each) do
      @tweet = create(:tweet)
    end
    it "should not allow the user_id to be changed" do
      expect{ (@tweet.update(:user_id => @tweet.id + 1))} .to raise_error(RuntimeError, "tweets can not be updated")
    end

    it "should not allow the created_at time to be changed" do
      expect{ (@tweet.update(:created_at => Time.now))} .to raise_error(RuntimeError, "tweets can not be updated")
    end

    it "should not allow the content to be changed" do
      expect{ (@tweet.update(:content => Time.now.to_s))} .to raise_error(RuntimeError, "tweets can not be updated")

    end

  end
end
