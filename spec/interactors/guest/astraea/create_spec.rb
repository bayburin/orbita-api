require 'rails_helper'

module Guest
  module Astraea
    RSpec.describe Create do
      subject(:context) { described_class.call }
      before do
        allow(::SdRequests::ValidateForm).to receive(:call!).and_return(true)
        allow(::SdRequests::Save).to receive(:call!).and_return(true)
      end

      describe '.call' do
        it { expect(context).to be_a_success }
      end
    end
  end
end
