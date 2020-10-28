require 'rails_helper'

module Histories
  RSpec.describe CreateComment do
    let(:event_type) { create(:event_type, :comment) }
    let(:user) { create(:admin) }
    let(:claim) { create(:claim) }
    let(:work) { create(:work, claim: claim) }
    let(:message) { 'Test comment' }
    let(:event_dbl) { double(:event, event_type: event_type, user: user, claim: claim, work: work, payload: { message: message }.as_json) }
    subject(:context) { described_class.call(event: event_dbl) }

    describe '.call' do
      it { expect(context).to be_a_success }
      it { expect { context }.to change { History.count } }
      it { expect(context.history.action).to eq event_type.template.gsub(/{comment}/, message) }

      context 'when history was not created' do
        let(:errors_dbl) { double(:errors, full_messages: ['error message']) }
        before do
          allow_any_instance_of(History).to receive(:save).and_return(false)
          allow_any_instance_of(History).to receive(:errors).and_return(errors_dbl)
        end

        it { expect(context).to be_a_failure }
        it { expect { context }.not_to change { History.count } }
        it { expect(context.error).to eq errors_dbl.full_messages }
      end
    end
  end
end
