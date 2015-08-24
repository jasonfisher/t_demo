require 'rails_helper'
require 'spec_helper'

RSpec.describe UsersController, type: :controller do

  describe "get :home" do
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
      it "should redirect to user#show page for logged in user" do
        get :home
        expect(response).to redirect_to show_user_path(@user.id)
      end
    end
  end

end
