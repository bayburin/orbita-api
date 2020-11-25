require 'rails_helper'

module SdRequests
  RSpec.describe Build821 do
    let(:sd_request) { build(:sd_request) }
    subject(:context) { described_class.call(params: {}) }
    before do
      allow(SdRequestBuilder).to receive(:build).and_return(sd_request)
      allow(SourceSnapshotBuilder).to receive(:build).and_return(sd_request.source_snapshot)
    end

    describe '.call' do
      it { expect(context.sd_request).to be_instance_of SdRequest }
      it { expect(context).to be_a_success }
    end
  end
end
