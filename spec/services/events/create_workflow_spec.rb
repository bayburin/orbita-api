require 'rails_helper'

module Events
  RSpec.describe CreateWorkflow do
    let!(:workflow_event_type) { create(:event_type, :workflow) }
    let(:claim) { create(:claim) }
    let(:work) { create(:work, claim: claim) }
    let(:message) { 'test message' }
    let(:event_dbl) do
      instance_double(
        'Event',
        event_type: workflow_event_type,
        claim: claim,
        work: work,
        user: create(:manager),
        payload: { message: message }.as_json
      )
    end
    let(:history_store_dbl) { instance_double('Histories::Storage', add: true, save!: true) }
    let(:history_dbl) { double(:history) }
    let(:workflow_type_dbl) { instance_double('Histories::WorkflowType', build: history_dbl) }
    subject(:context) { described_class.call(event: event_dbl, history_store: history_store_dbl) }

    describe '.call' do
      before do
        allow(history_store_dbl).to receive(:work=)
        allow(Histories::WorkflowType).to receive(:new).and_return(workflow_type_dbl)
        allow(SdRequests::BroadcastUpdatedRecordWorker).to receive(:perform_async)
      end

      it { expect(context).to be_a_success }
      it { expect(context.workflow.message).to eq message }
      it { expect(context.workflow.work_id).to eq work.id }

      it 'add history to history_store' do
        expect(history_store_dbl).to receive(:add).with(history_dbl)

        context
      end

      it 'save history' do
        expect(history_store_dbl).to receive(:save!)

        context
      end

      it 'call SdRequests::BroadcastUpdatedRecordWorker worker' do
        expect(SdRequests::BroadcastUpdatedRecordWorker).to receive(:perform_async).with(claim.id)

        context
      end

      context 'when workflow was not saved' do
        let(:errors_dbl) { double(:errors, full_messages: ['error message']) }
        before do
          allow_any_instance_of(Workflow).to receive(:save).and_return(false)
          allow_any_instance_of(Workflow).to receive(:errors).and_return(errors_dbl)
        end

        it { expect(context).to be_a_failure }
        it { expect(context.error).to eq errors_dbl.full_messages }

        it 'does not save history' do
          expect(history_store_dbl).not_to receive(:save!)

          context
        end
      end
    end
  end
end
