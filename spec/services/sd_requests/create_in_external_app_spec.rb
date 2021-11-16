require 'rails_helper'

module SdRequests
  RSpec.describe CreateInExternalApp do
    let(:sd_request) { create(:sd_request, ticket_identity: 783) }
    let(:response_dbl) { double('response', success?: true, body: { id: 123 }.to_json) }
    subject(:context) { described_class.call(sd_request: sd_request) }
    before do
      create(:oauth_application, name: 'СВТ')
      allow(Api).to receive(:create).and_return(response_dbl)
    end

    describe '.call' do
      it { expect(context).to be_a_success }

      it 'call Api#create method' do
        expect(Api).to receive(:create)

        context
      end

      it 'create ClaimApplication' do
        context

        expect(sd_request.claim_applications.length).to eq 1
      end
    end
  end
end
