require 'rails_helper'

module Employees
  RSpec.describe Authorize do
    let(:body) { { token: 'fake-body' } }
    let(:response) { double(:response, success?: true, body: body.as_json) }
    subject(:context) { described_class.call }
    before { allow(Employees::Api).to receive(:token).and_return(response) }

    describe '.call' do
      it { expect(context).to be_a_success }
      it { expect(context.token).to eq body[:token] }

      it 'save token into redis' do
        expect(TokenCache).to receive(:token=).with(body[:token])

        context
      end

      context 'and when "token" method finished with failure status' do
        let(:body) { { message: 'Unauthorized' } }
        let(:response) { double(:response, success?: false, body: body) }

        it { expect(context).to be_a_failure }
        it { expect(context.error).to eq body }
      end
    end
  end
end
