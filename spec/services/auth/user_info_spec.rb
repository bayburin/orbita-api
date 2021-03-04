require 'rails_helper'

module Auth
  RSpec.describe UserInfo do
    let(:auth_data) { { access_token: 'fake-token' }.as_json }
    let(:params) { { auth_data: auth_data } }
    let(:body) { 'fake-body' }
    let(:response) { double(:response, success?: true, body: body) }
    subject(:context) { described_class.call(params) }

    before { allow(Api::AuthCenter).to receive(:login_info).and_return(response) }

    describe '.call' do
      it 'finished with success' do
        expect(context).to be_a_success
      end

      it 'call "user_info" method with "access_token" param' do
        expect(Api::AuthCenter).to receive(:login_info).with(auth_data['access_token']).and_return(response)

        context
      end

      it 'save response body into "user_info" context' do
        expect(context.user_info).to eq body
      end

      context 'when "user_info" method return false' do
        let(:status) { 401 }
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
