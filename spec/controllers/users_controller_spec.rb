require 'rails_helper'

RSpec.describe UsersController, type: :controller do

  describe "GET #self" do
    it "returns http success" do
      get :self
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET #other" do
    it "returns http success" do
      get :other
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET #all" do
    it "returns http success" do
      get :all
      expect(response).to have_http_status(:success)
    end
  end

end
