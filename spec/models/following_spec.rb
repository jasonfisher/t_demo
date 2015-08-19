require 'rails_helper'
require 'spec_helper'
require 'factory_girl'

RSpec.describe Following, type: :model do

    context "when creating a Following" do

      context "with invalid parameters" do
        it "fails validation with no follower_id" do
          expect(Following.create(:follower_id => nil).errors[:follower_id].size).to eq(1)
          expect(Following.create(:follower_id => nil).errors[:follower_id]).to include("can't be blank")
        end

        it "fails validation with no followed_id" do
          expect(Following.create(:followed_id => nil).errors[:followed_id].size).to eq(1)
          expect(Following.create(:followed_id => nil).errors[:followed_id]).to include("can't be blank")
        end

        it "does not allow duplicate followings" do
          user_1 = create(:user)
          user_2 = create(:user)
          Following.create(:followed_id => user_1.id, :follower_id => user_2.id)
          expect(Following.create(:followed_id => user_1.id, :follower_id => user_2.id).errors[:follower_id]).to include("already following that user")
        end
      end

    end

  end
