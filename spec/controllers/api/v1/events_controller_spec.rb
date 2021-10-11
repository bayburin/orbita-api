require 'rails_helper'

RSpec.describe Api::V1::EventsController, type: :controller do
  sign_in_user

  describe 'POST #create' do
    let(:params) { { event: { claim_id: create(:claim).id } } }
    before { allow(Events::Create).to receive(:call).and_return(create_dbl) }

    context 'when interactor finished with success' do
      let(:create_dbl) { double(:create, success?: true, message: I18n.t('controllers.api.v1.events.processed_successfully')) }

      it 'call Events::Create.call method' do
        expect(Events::Create).to receive(:call).and_return(create_dbl)

        post :create, params: params
      end

      it 'respond with success status' do
        post :create, params: params

        expect(response.status).to eq 200
      end

      it 'respond with message' do
        post :create, params: params

        expect(parse_json(response.body)['message']).to eq create_dbl.message
      end
    end

    context 'when interactor finished with fail' do
      let(:create_dbl) { double(:create, success?: false, error: 'errors') }

      it 'respond with error status' do
        post :create, params: params

        expect(response.status).to eq 400
      end

      it 'respond with error' do
        post :create, params: params

        expect(response.body).to eq({ error: create_dbl.error }.to_json)
      end
    end
  end
end
