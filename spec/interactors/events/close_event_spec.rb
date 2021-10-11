require 'rails_helper'

module Events
  RSpec.describe CloseEvent do
    let(:event) { instance_double('Event', claim: create(:claim), user: create(:manager)) }
    subject(:context) { described_class.call(event: event) }
    before do
      allow(FindOrCreateWork).to receive(:call!).and_return(true)
      allow(CloseClaim).to receive(:call!).and_return(true)
    end

    describe '.call' do
      it { expect(context).to be_a_success }

      it_behaves_like 'requirementable'
    end
  end
end
