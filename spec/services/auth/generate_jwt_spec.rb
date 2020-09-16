require 'rails_helper'

module Auth
  RSpec.describe GenerateJwt do
    let(:user) { create(:admin) }
    let(:params) { { user: user } }
    let(:jwt) { 'fake-jwt' }
    subject(:context) { described_class.call(params) }

    describe '.call' do
      it 'finished with success' do
        expect(context).to be_a_success
      end

      it 'save generated token into "jwt" attribute' do
        allow(JWT).to receive(:encode).and_return(jwt)

        expect(context.jwt).to eq jwt
      end
    end
  end
end
