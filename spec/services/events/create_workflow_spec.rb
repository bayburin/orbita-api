require 'rails_helper'

module Events
  RSpec.describe CreateWorkflow do
    let(:payload) { { message: 'Test payload message' }.as_json }
    let(:event) { double(:event, claim_id: claim.id, id_tn: user.id_tn, payload: payload) }
    let(:work) { create(:work) }
    let(:user) { create(:admin) }
    let(:claim) { create(:claim, works: [work]) }
    subject(:context) { described_class.call(claim: claim, work: work, user: user, event: event) }

    describe '.call' do
      it { expect(context).to be_a_success }
      it { expect { context }.to change { Workflow.count } }
      it { expect(context.workflow.message).to eq payload['message'] }

      context 'when workflow was not created' do
        let(:errors_dbl) { double(:errors, full_messages: ['error message']) }
        before do
          allow_any_instance_of(Workflow).to receive(:save).and_return(false)
          allow_any_instance_of(Workflow).to receive(:errors).and_return(errors_dbl)
        end

        it { expect(context).to be_a_failure }
        it { expect { context }.not_to change { Workflow.count } }
        it { expect(context.error).to eq errors_dbl.full_messages }
      end
    end
  end
end