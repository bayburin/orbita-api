require 'rails_helper'

RSpec.describe Api::V1::EventsController, type: :controller do
  sign_in_user

  describe 'POST #create' do
    let(:params) { { event: { foo: :bar } } }
    before { allow(Events::Handler).to receive(:call).and_return(handler_dbl) }

    context 'when handler finished with success' do
      let(:handler_dbl) { double(:handler, success?: true, message: I18n.t('controllers.api.v1.events.processed_successfully')) }

      it 'call Events::Handler.call method' do
        expect(Events::Handler).to receive(:call).and_return(handler_dbl)

        post :create, params: params
      end

      it 'respond with success status' do
        post :create, params: params

        expect(response.status).to eq 200
      end

      it 'respond with message' do
        post :create, params: params

        expect(parse_json(response.body)['message']).to eq handler_dbl.message
      end
    end

    context 'when handler finished with fail' do
      let(:handler_dbl) { double(:handler, success?: false, error: { error: 'errors' }) }

      it 'respond with error status' do
        post :create, params: params

        expect(response.status).to eq 422
      end

      it 'respond with error' do
        post :create, params: params

        expect(response.body).to eq({ error: handler_dbl.error }.to_json)
      end
    end
  end
end
