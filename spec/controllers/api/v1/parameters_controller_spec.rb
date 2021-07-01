require 'rails_helper'

RSpec.describe Api::V1::ParametersController, type: :controller do
  sign_in_user

  describe 'GET #index' do
    let!(:sd_requests) { create_list(:sd_request, 2) }
    let!(:parameters_1) { create_list(:parameter, 2, claim_id: sd_requests.first.id) }
    let!(:parameters_2) { create_list(:parameter, 3, claim_id: sd_requests.last.id) }
    let(:params) { { sd_request_id: sd_requests.first.id } }

    it 'respond with finded data' do
      get :index, params: params

      expect(response.body).to have_json_size(2).at_path('parameters')
    end

    it 'does not include another parameters' do
      get :index, params: params

      expect(parse_json(response.body)['parameters'].any? { |p| p['claim_id'] == sd_requests.last.id }).to be_falsey
    end

    it 'respond with success status' do
      get :index, params: params

      expect(response.status).to eq 200
    end
  end
end
