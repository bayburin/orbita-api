require 'rails_helper'

RSpec.describe Api::V1::SdRequestsController, type: :controller do
  sign_in_user

  describe 'POST #create' do
    let(:params) { { sd_request: { service_id: 1 } } }
    let!(:sd_request) { create(:sd_request) }
    before do
      allow(SdRequestForm).to receive(:new).and_return(create_form_dbl)
    end

    context 'when form saved data' do
      let(:create_form_dbl) { double(:create_form, validate: true, save: true, model: sd_request) }

      it 'create instnace of SdRequestForm' do
        expect(SdRequestForm).to receive(:new).with(an_instance_of(SdRequest))

        post :create, params: params
      end

      it 'respond with success status' do
        post :create, params: params

        expect(response.status).to eq 200
      end

      it 'respond with created model' do
        post :create, params: params

        expect(parse_json(response.body)['id']).to eq create_form_dbl.model.id
      end

    end

    context 'when form finished with fail' do
      let(:create_form_dbl) { double(:create_form, validate: true, save: false, errors: { error: 'errors' }) }

      it 'respond with error status' do
        post :create, params: params

        expect(response.status).to eq 422
      end

      it 'respond with error' do
        post :create, params: params

        expect(response.body).to eq({ error: create_form_dbl.errors }.to_json)
      end
    end
  end
end
