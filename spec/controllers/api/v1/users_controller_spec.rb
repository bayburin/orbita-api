require 'rails_helper'

RSpec.describe Api::V1::UsersController, type: :controller do
  sign_in_user

  describe 'GET #index' do
    before do
      create(:admin)
      create(:manager)
    end

    it 'repond with all users' do
      get :index

      expect(response.body).to have_json_size(User.count)
    end

    it 'respond with success status' do
      get :index

      expect(response.status).to eq 200
    end
  end
end