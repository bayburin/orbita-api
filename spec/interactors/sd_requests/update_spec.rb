require 'rails_helper'

module SdRequests
  RSpec.describe Update do
    subject(:context) { described_class.call }

    describe '.call' do
      it { expect(context).to be_a_success }
    end
  end
end
