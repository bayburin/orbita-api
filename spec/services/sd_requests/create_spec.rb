require 'rails_helper'

module SdRequests
  RSpec.describe Create do
    subject(:context) { described_class.call() }
    before do
      allow(Build).to receive(:call!).and_return(true)
      allow(Save).to receive(:call!).and_return(true)
    end

    describe '.call' do
      it { expect(context).to be_a_success }
    end
  end
end
