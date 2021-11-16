require 'rails_helper'

RSpec.describe Guest::Api::V1::AstraeaController, type: :controller do
  sign_in_employee

  describe 'POST #create' do
    let(:params) { { id_tn: 123, sd_request: attributes_for(:astraea_kase) } }
    let!(:sd_request) { create(:sd_request) }
    let(:create_form_dbl) { double(:create_form, success?: true, sd_request: sd_request, error: 'errors') }
    before { allow(Guest::Astraea::Create).to receive(:call).and_return(create_form_dbl) }

    context 'when form saved data' do
      it 'call SdRequests::Create.call method' do
        expect(Guest::Astraea::Create).to receive(:call)

        post :create, params: params, as: :json
      end

      it 'respond with success status' do
        post :create, params: params, as: :json

        expect(response.status).to eq 200
      end
    end

    context 'when form finished with fail' do
      before { allow(create_form_dbl).to receive(:success?).and_return(false) }

      it 'respond with error status' do
        post :create, params: params, as: :json

        expect(response.status).to eq 400
      end

      it 'respond with error' do
        post :create, params: params, as: :json

        expect(response.body).to eq({ error: create_form_dbl.error }.to_json)
      end
    end
  end

  describe 'PUT #update' do
    let!(:sd_request) { create(:sd_request) }
    let!(:claim_application) { create(:claim_application, claim: sd_request, integration_id: 456, application_id: access_token.application.id) }
    let(:params) { { id: claim_application.integration_id, id_tn: 123, sd_request: attributes_for(:astraea_kase) } }
    let(:update_form_dbl) { double(:update_form, success?: true, sd_request: sd_request, error: 'errors') }
    before do
      allow(SdRequest).to receive(:find_by).and_return(sd_request)
      allow(Guest::Astraea::Update).to receive(:call).and_return(update_form_dbl)
    end

    context 'when claim not found' do
      before { allow_any_instance_of(ClaimsQuery).to receive_message_chain(:search_by_integration, :includes, :first).and_return(nil) }

      it 'respond with 404 status' do
        put :update, params: params, as: :json

        expect(response.status).to eq 404
      end
    end

    context 'when form saved data' do
      it 'call SdRequests::Update.call method' do
        expect(Guest::Astraea::Update).to receive(:call)

        put :update, params: params, as: :json
      end

      it 'respond with success status' do
        put :update, params: params, as: :json

        expect(response.status).to eq 200
      end
    end

    context 'when form finished with fail' do
      before { allow(update_form_dbl).to receive(:success?).and_return(false) }

      it 'respond with error status' do
        put :update, params: params, as: :json

        expect(response.status).to eq 400
      end

      it 'respond with error' do
        put :update, params: params, as: :json

        expect(response.body).to eq({ error: update_form_dbl.error }.to_json)
      end
    end
  end
end
