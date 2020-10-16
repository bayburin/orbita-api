require 'rails_helper'

RSpec.describe Api::V1::AuthController, type: :controller do
  describe 'POST #token' do
    let(:params) { { auth: { code: 'fake-code' } } }
    let(:jwt) { 'fake-jwt' }
    let(:result) { double(:result, success?: true, jwt: jwt) }

    before { allow(Auth::Authorize).to receive(:call).and_return(result) }

    it 'call Auth::Authorize command' do
      expect(Auth::Authorize).to receive(:call).with(code: params[:auth][:code]).and_return(result)

      post :token, params: params, format: :json
    end

    it 'respond with jwt' do
      post :token, params: params, format: :json

      expect(response.body).to eq({ token: jwt }.to_json)
    end

    it 'respond with success status' do
      post :token, params: params, format: :json

      expect(response.status).to eq(200)
    end

    context 'when command finished with fail' do
      let(:message) { 'fake-error-message' }
      let(:result) { double(:result, success?: false, message: message) }

      it 'respond with error message' do
        post :token, params: params, format: :json

        expect(response.body).to eq({ message: message }.to_json)
      end

      it 'respond with unauthorized status' do
        post :token, params: params, format: :json

        expect(response.status).to eq(400)
      end
    end
  end
end
