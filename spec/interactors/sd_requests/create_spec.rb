require 'rails_helper'

module SdRequests
  RSpec.describe Create do
    subject(:context) { described_class.call }
    before do
      allow(ValidateForm).to receive(:call!).and_return(true)
      allow(Save).to receive(:call!).and_return(true)
      allow(NotifyOnCreate).to receive(:call!).and_return(true)
      allow(BroadcastOnCreate).to receive(:call!).and_return(true)
      allow(Astraea::CreateSdRequest).to receive(:call!).and_return(true)
    end

    describe '.call' do
      it { expect(context).to be_a_success }
    end
  end
end
