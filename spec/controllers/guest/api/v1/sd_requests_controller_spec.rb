require 'rails_helper'

RSpec.describe Guest::Api::V1::SdRequestsController, type: :controller do
  sign_in_employee

  describe 'POST #create' do
    let(:params) { { sd_request: { service_id: 1 } } }
    let!(:sd_request) { create(:sd_request) }
    before { allow(Guest::SdRequests::Create).to receive(:call).and_return(create_form_dbl) }

    context 'when form saved data' do
      let(:create_form_dbl) { double(:create_form, success?: true, sd_request: sd_request) }

      it 'call SdRequests::Create.call method' do
        expect(Guest::SdRequests::Create).to receive(:call).and_return(create_form_dbl)

        post :create, params: params, format: :json
      end

      it 'respond with success status' do
        post :create, params: params, format: :json

        expect(response.status).to eq 200
      end

      it 'respond with created model' do
        post :create, params: params, format: :json

        expect(parse_json(response.body)['id']).to eq create_form_dbl.sd_request.id
      end
    end

    context 'when form finished with fail' do
      let(:create_form_dbl) { double(:create_form, success?: false, error: 'errors') }

      it 'respond with error status' do
        post :create, params: params, format: :json

        expect(response.status).to eq 400
      end

      it 'respond with error' do
        post :create, params: params, format: :json

        expect(response.body).to eq(create_form_dbl.error)
      end
    end
  end
end
