require 'rails_helper'

RSpec.describe ClaimsController, type: :controller do
  describe 'GET #index' do
    before { create_list(:claim, 3) }

    it 'repond with all claims' do
      get :index

      expect(response.body).to have_json_size(Claim.count)
    end

    it 'respond with success status' do
      get :index

      expect(response.status).to eq 200
    end
  end
end