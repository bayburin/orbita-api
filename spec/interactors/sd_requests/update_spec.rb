require 'rails_helper'

module SdRequests
  RSpec.describe Update do
    subject(:context) { described_class.call }
    before do
      allow(ValidateUpdateForm).to receive(:call!).and_return(true)
      allow(SaveUpdateForm).to receive(:call!).and_return(true)
    end

    describe '.call' do
      it { expect(context).to be_a_success }
    end
  end
end
