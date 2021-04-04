require 'rails_helper'

RSpec.describe Guest::Api::V1::ServiceDeskController, type: :controller do
  sign_in_employee

  describe 'POST #create' do
    let(:params) { { app: { desc: 'test' } } }

    it 'respond with success status' do
      post :create, params: params, format: :json

      expect(response.status).to eq 200
    end
  end
end
