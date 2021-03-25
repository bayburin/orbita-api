require 'rails_helper'

module SdRequests
  RSpec.describe NotifyOnUpdate do
    let(:sd_request) { create(:sd_request) }
    subject(:context) { described_class.call(sd_request: sd_request) }

    describe '.call' do
      it 'call SdRequests::UpdatedWorker worker' do
        expect(SdRequests::UpdatedWorker).to receive(:perform_async).with(sd_request.id)

        context
      end
    end
  end
end
