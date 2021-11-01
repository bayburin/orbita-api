require 'rails_helper'

module SdRequests
  RSpec.describe CreateInExternalApp do
    let(:sd_request) { create(:sd_request) }
    let(:response_dbl) { double('response', success?: true) }
    subject(:context) { described_class.call(sd_request: sd_request) }
    before do
      allow(Api).to receive(:create).and_return(response_dbl)
    end

    describe '.call' do
      it { expect(context).to be_a_success }

      it 'call Api#create method' do
        expect(Api).to receive(:create)

        context
      end
    end
  end
end
