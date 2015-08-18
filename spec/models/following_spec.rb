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

    end

  end
