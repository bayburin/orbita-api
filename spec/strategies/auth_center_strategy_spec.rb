require 'rails_helper'

RSpec.describe AuthCenterStrategy, type: :request do
  describe 'GET /api/v1/welcome' do
    let!(:user) { create(:admin) }
    let(:user_info) { { id_tn: user.id_tn } }
    let(:access_token) { 'fake-token' }
    let(:headers) { { Authorization: "Bearer #{access_token}" }.as_json }

    it 'call "success!" method with User instance for AuthCenterStrategy instance' do
      allow(AuthCenter::JsonWebToken).to receive(:decode).with(access_token).and_return(user_info)
      expect_any_instance_of(Warden::Strategies::Base).to receive(:success!).with(user)

      get '/api/v1/welcome.json', headers: headers
    end

    context 'when JWT is invalid' do
      it 'return with error message' do
        allow(AuthCenter::JsonWebToken).to receive(:decode).with(access_token).and_raise(JWT::DecodeError)
        get '/api/v1/welcome.json', headers: headers

        expect(response.body).to be_json_eql({ error: 'Не валидный токен' }.to_json)
      end
    end

    context 'when user not found' do
      it 'return with error message' do
        allow(AuthCenter::JsonWebToken).to receive(:decode).with(access_token).and_return(user_info)
        allow(User).to receive(:find_by).and_return(nil)
        get '/api/v1/welcome.json', headers: headers

        expect(response.body).to be_json_eql({ error: 'Доступ запрещен' }.to_json)
      end
    end
  end
end
