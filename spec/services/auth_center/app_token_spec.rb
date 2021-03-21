require 'rails_helper'

module AuthCenter
  RSpec.describe AppToken do
    let(:body) { 'fake-body' }
    let(:response) { double(:response, success?: true, body: body) }
    subject(:context) { described_class.call }
    before { allow(AuthCenter::AppTokenCache).to receive(:token).and_return(body) }

    describe '.call' do
      it { expect(context).to be_a_success }
      it { expect(context.token).to eq body }

      context 'when token does not exist' do
        before do
          allow(AuthCenter::AppTokenCache).to receive(:token)
          allow(Api).to receive(:app_token).and_return(response)
        end

        it 'call Api.app_token method' do
          expect(Api).to receive(:app_token).and_return(response)

          context
        end

        it 'save response body into "token" context' do
          expect(context.token).to eq body
        end

        it 'save token into redis' do
          expect(AuthCenter::AppTokenCache).to receive(:token=).with(body)

          context
        end

        context 'and when "app_token" method return false' do
          let(:status) { 400 }
          let(:response) { double(:response, success?: false, body: body, status: status) }

          it { expect(context).to be_a_failure }
          it { expect(context.error).to eq body }
        end
      end
    end
  end
end
