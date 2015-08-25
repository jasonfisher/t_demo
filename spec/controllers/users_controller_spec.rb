require 'rails_helper'
require 'spec_helper'

RSpec.describe UsersController, type: :controller do

  describe "get #home" do
    context "when user is not logged in" do
      it "should redirect to login page " do
        login_with nil
        get :home
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context "when user is logged in" do
      before(:each) do
        @user = create(:user)
        login_with @user
      end
      it "should redirect to user's# show page" do
        get :home
        expect(response).to redirect_to show_user_path(@user.id)
      end
    end
  end

  describe "get #show" do
    context "when user is not logged in" do
      it "should redirect to login page " do
        login_with nil
        get :show, :id => Random.rand(1999999)
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context "when user is logged in" do
      before(:each) do
        @user = create(:user)
        login_with @user
      end
      it "should return success" do
        get :show, :id => @user.id
        expect(response).to be_success
      end

      it "should return :show template" do
        get :show, :id => @user.id
        expect(response).to render_template :show
      end

#TODO/NOTE: content is slightly different if one's own page vs somebody else's; tried for too long ot find a way to compare against
      # content of the response body to test this but had to stop due to time contsraints

      context "when a user tries to view another user's home page" do
        it "should render :show template for whatever user id is given" do
          @user2 = create(:user)
          get :show, :id => @user2.id
          expect(response).to render_template :show
        end
      end
    end
  end

  describe "get show_followers" do
    context "when user is not logged in" do
      it "should redirect to login page " do
        login_with nil
        get :show_followers, :id => Random.rand(1999999)
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context "when user is logged in" do
      before(:each) do
        @user = create(:user)
        login_with @user
      end
      it "should return success" do
        get :show_followers, :id => @user.id
        expect(response).to be_success
      end

      it "should render :show_followers template for whatever user id is given" do
        get :show_followers, :id => @user.id
        expect(response).to render_template :show_followers
        @user2 = create(:user)
        get :show_followers, :id => @user2.id
        expect(response).to render_template :show_followers
      end
    end
  end

  describe "get show_followeds" do
    context "when user is not logged in" do
      it "should redirect to login page " do
        login_with nil
        get :show_followeds, :id => Random.rand(1999999)
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context "when user is logged in" do
      before(:each) do
        @user = create(:user)
        login_with @user
      end
      it "should return success" do
        get :show_followeds, :id => @user.id
        expect(response).to be_success
      end

      it "should render :show_followeds template for whatever user id is given" do
        get :show_followeds, :id => @user.id
        expect(response).to render_template :show_followeds
        @user2 = create(:user)
        get :show_followeds, :id => @user2.id
        expect(response).to render_template :show_followeds
      end
    end
  end

end
