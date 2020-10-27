require 'rails_helper'

module Events
  RSpec.describe WorkflowEvent do
    let(:user) { create(:admin) }
    let(:claim) { create(:claim) }
    let(:payload) { { message: 'Test payload message' }.as_json }
    let(:event) { double(:event, claim: claim, user: user, payload: payload) }
    subject(:context) { described_class.call(event: event) }
    before do
      allow(FindOrCreateWork).to receive(:call!).and_return(true)
      allow(CreateWorkflow).to receive(:call!).and_return(true)
      allow(Histories::CreateWorkflow).to receive(:call!).and_return(true)
    end

    describe '.call' do
      it { expect(context).to be_a_success }

      context 'when Claim does not exist' do
        let!(:claim) { nil }

        it { expect(context).to be_a_failure }
        it { expect(context.error).to eq 'Заявка не найдена' }
      end

      context 'when User does not exist' do
        let!(:user) { nil }

        it { expect(context).to be_a_failure }
        it { expect(context.error).to eq 'Пользователь не найден' }
      end
    end
  end
end
