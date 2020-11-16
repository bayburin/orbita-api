require 'rails_helper'

module Claims
  RSpec.describe Build821 do
    let(:claim) { build(:claim) }
    subject(:context) { described_class.call(params: {}) }
    before { allow(ApplicationBuilder).to receive(:build).and_return(claim) }

    describe '.call' do
      it { expect(context.claim).to be_instance_of Claim }
      it { expect(context).to be_a_success }
    end
  end
end
