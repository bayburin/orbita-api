require 'rails_helper'

module Events
  RSpec.describe WorkflowEvent do
    let(:user) { create(:admin) }
    let(:claim) { create(:claim) }
    let(:event_dbl) { double(:event, claim: claim, user: user) }
    subject(:context) { described_class.call(event: event_dbl) }
    before do
      allow(FindOrCreateWork).to receive(:call!).and_return(true)
      allow(CreateWorkflow).to receive(:call!).and_return(true)
      allow(Histories::CreateWorkflow).to receive(:call!).and_return(true)
    end

    describe '.call' do
      it { expect(context).to be_a_success }

      it_behaves_like 'requirementable'
    end
  end
end
