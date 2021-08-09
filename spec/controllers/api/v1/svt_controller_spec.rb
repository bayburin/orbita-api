require 'rails_helper'

RSpec.describe Api::V1::SvtController, type: :controller do
  sign_in_user

  describe 'GET #items' do
    let(:params) { { filters: { invent_num: '123' }.to_json } }
    let(:body) { { foo: :bar } }
    let(:response_dbl) { double(:svt_response, body: body.as_json, status: 200) }
    before { allow(Svt::Api).to receive(:query_items).and_return(response_dbl) }

    it 'calls Svt::Api.query method' do
      expect(Svt::Api).to receive(:query_items).with(JSON.parse(params[:filters]))

      get :items, params: params
    end

    it 'respond with received data' do
      get :items, params: params

      expect(response.body).to eq body.to_json
    end

    it 'respond with received status' do
      get :items, params: params

      expect(response.status).to eq 200
    end
  end

  describe 'GET #find_by_barcode' do
    let(:params) { { barcode: 123 } }
    let(:body) { { foo: :bar } }
    let(:response_dbl) { double(:svt_response, body: body.as_json, status: 200) }
    before { allow(Svt::Api).to receive(:find_by_barcode).and_return(response_dbl) }

    it 'calls Svt::Api.find_by_barcode method' do
      expect(Svt::Api).to receive(:find_by_barcode).with('123')

      get :find_by_barcode, params: params
    end

    it 'respond with received data' do
      get :find_by_barcode, params: params

      expect(response.body).to eq body.to_json
    end

    it 'respond with received status' do
      get :find_by_barcode, params: params

      expect(response.status).to eq 200
    end
  end
end
