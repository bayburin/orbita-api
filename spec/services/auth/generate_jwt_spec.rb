require 'rails_helper'

module Auth
  RSpec.describe GenerateJwt do
    let(:user) { create(:admin) }
    let(:params) { { user: user } }
    let(:jwt) { 'fake-jwt' }
    let(:user_data) { { tn: 'fake-tn' } }
    subject(:context) { described_class.call(params) }

    describe '.call' do
      it 'finished with success' do
        expect(context).to be_a_success
      end

      it 'generate token with serialized user data' do
        allow(UserSerializer).to receive(:new).with(params[:user]).and_return(user_data)
        expect(JsonWebToken).to receive(:encode).with(user_data.as_json)

        context
      end

      it 'save generated token into "jwt" attribute' do
        allow(JsonWebToken).to receive(:encode).and_return(jwt)

        expect(context.jwt).to eq jwt
      end
    end
  end
end
