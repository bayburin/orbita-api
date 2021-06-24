require 'rails_helper'

RSpec.describe Api::V1::SdRequestsController, type: :controller do
  sign_in_user

  describe 'POST #show', focus: true do
    let!(:sd_request) { create(:sd_request) }
    let(:params) { { id: sd_request.id } }

    it 'respond with sd_request' do
      get :show, params: params

      expect(parse_json(response.body)['sd_request']['id']).to eq sd_request.id
    end

    it 'respond with success status' do
      get :show, params: params

      expect(response.status).to eq 200
    end

    context 'when sd_request was not found' do
      before { get :show, params: { id: 123 } }

      it { expect(parse_json(response.body)['sd_request']).to be_nil }
      it { expect(response.status).to eq 404 }
    end
  end

  describe 'POST #create' do
    let(:params) { { sd_request: { service_id: 1 } } }
    let!(:sd_request) { create(:sd_request) }
    before { allow(SdRequests::Create).to receive(:call).and_return(create_form_dbl) }

    context 'when form saved data' do
      let(:create_form_dbl) { double(:create_form, success?: true, sd_request: sd_request) }

      it 'call SdRequests::Create.call method' do
        expect(SdRequests::Create).to receive(:call).and_return(create_form_dbl)

        post :create, params: params
      end

      it 'respond with success status' do
        post :create, params: params

        expect(response.status).to eq 200
      end

      it 'respond with created model' do
        post :create, params: params

        expect(parse_json(response.body)['sd_request']['id']).to eq create_form_dbl.sd_request.id
      end
    end

    context 'when form finished with fail' do
      let(:create_form_dbl) { double(:create_form, success?: false, error: 'errors') }

      it 'respond with error status' do
        post :create, params: params

        expect(response.status).to eq 400
      end

      it 'respond with error' do
        post :create, params: params

        expect(response.body).to eq(create_form_dbl.error)
      end
    end
  end

  describe 'PUT #update' do
    let!(:sd_request) { create(:sd_request) }
    let(:params) { { id: sd_request.id, sd_request: { service_id: 2 } } }
    let(:error) { { foo: 'bar' } }
    let(:update_form_dbl) { double(:update_form, success?: true, sd_request: sd_request, error: error) }
    before { allow(SdRequests::Update).to receive(:call).and_return(update_form_dbl) }

    context 'when data updated' do
      it 'call SdRequests::Update.call method' do
        expect(SdRequests::Update).to receive(:call).and_return(update_form_dbl)

        put :update, params: params
      end

      it 'respond with success status' do
        put :update, params: params

        expect(response.status).to eq 200
      end

      it 'respond with updated model' do
        put :update, params: params

        expect(parse_json(response.body)['sd_request']['id']).to eq update_form_dbl.sd_request.id
      end
    end

    context 'when update finished with failure' do
      before { allow(update_form_dbl).to receive(:success?).and_return(false) }

      it 'respond with error status' do
        put :update, params: params

        expect(response.status).to eq 400
      end

      it 'respond with error' do
        put :update, params: params

        expect(response.body).to eq(error.to_json)
      end
    end
  end
end
