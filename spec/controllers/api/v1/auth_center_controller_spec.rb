require 'rails_helper'

RSpec.describe Api::V1::AuthCenterController, type: :controller do
  sign_in_user

  describe 'GET #show' do
    let(:params) { { id: 123, idfield: 'name' } }
    let(:body) { { foo: :bar } }
    let(:response_dbl) { double(:ac_response, body: body.as_json, status: 200) }
    before { allow(AuthCenter::Api).to receive(:host_info).and_return(response_dbl) }

    it 'calls AuthCenter::Api.host_info method' do
      expect(AuthCenter::Api).to receive(:host_info).with(any_args, '123', 'name')

      get :show_host, params: params
    end

    it 'respond with received data' do
      get :show_host, params: params

      expect(response.body).to eq body.to_json
    end

    it 'respond with received status' do
      get :show_host, params: params

      expect(response.status).to eq 200
    end
  end

  describe 'GET #show_user_hosts' do
    let(:params) { { tn: 123 } }
    let(:body) { { foo: :bar } }
    let(:response_dbl) { double(:ac_response, body: body.as_json, status: 200) }
    before { allow(AuthCenter::Api).to receive(:host_list).and_return(response_dbl) }

    it 'calls AuthCenter::Api.host_info method' do
      expect(AuthCenter::Api).to receive(:host_list).with(any_args, '123')

      get :show_user_hosts, params: params
    end

    it 'respond with received data' do
      get :show_user_hosts, params: params

      expect(response.body).to eq({ hosts: body }.to_json)
    end

    it 'respond with received status' do
      get :show_user_hosts, params: params

      expect(response.status).to eq 200
    end
  end
end
