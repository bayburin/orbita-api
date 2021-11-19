require 'rails_helper'

module Events
  RSpec.describe CreateWorkers do
    let!(:add_workers_event_type) { create(:event_type, :add_workers) }
    let!(:claim) { create(:claim) }
    let!(:group) { create(:group) }
    let!(:user_1) { create(:manager, group: group) }
    let!(:work) { create(:work, claim: claim, group: group) }
    let!(:worker) { create(:worker, work: work, user: user_1) }
    let!(:user_2) { create(:manager, group: group) }
    let!(:user_3) { create(:manager) }
    let(:tns) { [user_2.tn, user_3.tn] }
    let(:event_dbl) do
      instance_double(
        'Event',
        event_type: add_workers_event_type,
        claim: claim,
        work: work,
        user: create(:manager),
        payload: { tns: tns }.as_json
      )
    end
    let(:history_store_dbl) { instance_double('Histories::Storage', add_to_combine: true, save!: true) }
    let(:history_dbl) { double(:history) }
    subject(:context) { described_class.call(event: event_dbl, history_store: history_store_dbl) }

    describe '.call' do
      before { allow(SdRequests::BroadcastUpdatedRecordWorker).to receive(:perform_async) }

      it { expect(context).to be_a_success }
      it { expect { context }.to change { Worker.count }.by(2) }
      it { expect { context }.to change { Work.count }.by(1) }
      it { expect(context.event.claim.works.find_by(group_id: user_2.group_id).workers.pluck(:user_id)).to include(user_2.id) }
      it { expect(context.event.claim.works.find_by(group_id: user_3.group_id).workers.count).to eq 1 }
      it { expect(context.event.claim.works.find_by(group_id: user_3.group_id).workers.first.user_id).to eq user_3.id }

      it 'add history to history_store' do
        expect(history_store_dbl).to receive(:add_to_combine).exactly(2).times

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

      context 'when new workers array is empty' do
        let(:event_dbl) do
          instance_double(
            'Event',
            event_type: add_workers_event_type,
            claim: claim,
            work: work,
            user: create(:manager),
            payload: { tns: [] }.as_json
          )
        end

        it { expect(context).to be_a_success }

        it 'does not save history' do
          expect(history_store_dbl).not_to receive(:save!)

          context
        end
      end

      context 'when any of worker was not saved' do
        let(:msg) { ['error message'] }
        let(:errors_dbl) { double(:errors, full_messages: msg) }
        let(:error_msg) { ["#{user_3.tn}: #{msg}", "#{user_2.tn}: #{msg}"] }
        before do
          allow_any_instance_of(Worker).to receive(:save).and_return(false)
          allow_any_instance_of(Worker).to receive(:errors).and_return(errors_dbl)
        end

        it { expect(context).to be_a_failure }
        it { expect(context.error).to eq error_msg }

        it 'does not save history' do
          expect(history_store_dbl).not_to receive(:save!)

          context
        end
      end
    end
  end
end
