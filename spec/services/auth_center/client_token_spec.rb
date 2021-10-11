require 'rails_helper'

module AuthCenter
  RSpec.describe ClientToken do
    let(:code) { 'fake-code' }
    let(:params) { { code: code } }
    let(:body) { 'fake-body' }
    let(:response) { double(:response, success?: true, body: body) }
    subject(:context) { described_class.call(params) }

    before { allow(Api).to receive(:client_token).and_return(response) }

    describe '.call' do
      it 'finished with success' do
        expect(context).to be_a_success
      end

      it 'call "client_token" method with "code" param' do
        expect(Api).to receive(:client_token).with(code).and_return(response)

        context
      end

      it 'save response body into "auth_data" context' do
        expect(context.auth_data).to eq body
      end

      context 'when "client_token" method return false' do
        let(:status) { 400 }
        let(:response) { double(:response, success?: false, body: body, status: status) }

        it 'finished with fail' do
          expect(context).to be_a_failure
        end

        it 'set message to context' do
          expect(context.message).to eq body
        end

        it 'set status to context' do
          expect(context.status).to eq status
        end
      end
    end
  end
end
