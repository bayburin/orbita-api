require 'rails_helper'

RSpec.describe ServiceDesk::Api::V1::SdRequestsController, type: :controller do
  sign_in_employee

  describe 'POST #create' do
    let(:params) { { sd_request: { desc: 'test' }.to_json, id_tn: 123 } }

    it 'respond with success status' do
      post :create, params: params, format: :json

      expect(response.status).to eq 200
    end
  end
end
