require 'rails_helper'

RSpec.describe TweetsController, type: :controller do

  describe "get show_tweets" do
    context "when user is not logged in" do
      it "should redirect to login page " do
        login_with nil
        get :show_tweets, :id => Random.rand(1999999)
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context "when user is logged in" do
      before(:each) do
        @user = create(:user)
        login_with @user
      end
      it "should return success" do
        get :show_tweets, :id => @user.id
        expect(response).to be_success
      end

      it "should render :show_tweets template for whatever user id is given" do
        get :show_tweets, :id => @user.id
        expect(response).to render_template :show_tweets
        @user2 = create(:user)
        get :show_tweets, :id => @user2.id
        expect(response).to render_template :show_tweets
      end
    end
  end

end
