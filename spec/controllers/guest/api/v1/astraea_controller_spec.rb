require 'rails_helper'

RSpec.describe Guest::Api::V1::AstraeaController, type: :controller do
  sign_in_employee

  describe 'POST #create' do
    let(:params) { { id_tn: 123, sd_request: attributes_for(:astraea_kase) } }
    let!(:sd_request) { create(:sd_request) }
    let(:create_form_dbl) { double(:create_form, success?: true, sd_request: sd_request, error: 'errors') }
    before do
      allow(Guest::Astraea::Create).to receive(:call).and_return(create_form_dbl)
    end

    context 'when form saved data' do
      it 'call SdRequests::Create.call method' do
        expect(Guest::Astraea::Create).to receive(:call).and_return(create_form_dbl)

        post :create, params: params, as: :json
      end

      it 'respond with success status' do
        post :create, params: params, as: :json

        expect(response.status).to eq 200
      end

      # it 'respond with created model' do
      #   post :create, params: params, as: :json

      #   expect(parse_json(response.body)['id']).to eq create_form_dbl.sd_request.id
      # end
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
end