require 'rails_helper'

module Events
  RSpec.describe DeleteWorkers do
    let!(:del_workers_event_type) { create(:event_type, :del_workers) }
    let!(:claim) { create(:claim) }
    let!(:group) { create(:group) }
    let!(:user_1) { create(:manager, group: group) }
    let!(:work_1) { create(:work, claim: claim, group: group) }
    let!(:work_2) { create(:work, claim: claim) }
    let!(:user_2) { create(:manager, group: group) }
    let!(:user_3) { create(:manager) }
    let(:tns) { [user_1.tn, user_2.tn, user_3.tn] }
    let(:event_dbl) do
      instance_double(
        'Event',
        event_type: del_workers_event_type,
        claim: claim,
        work: work_1,
        user: create(:manager),
        payload: { tns: tns }.as_json
      )
    end
    let(:history_store_dbl) { instance_double('Histories::Storage', add_to_combine: true, save!: true) }
    let(:history_dbl) { double(:history) }
    subject(:context) { described_class.call(event: event_dbl, history_store: history_store_dbl) }
    before do
      work_1.users.push(user_1, user_2)
      work_2.users << user_3
    end

    describe '.call' do
      before { allow(SdRequests::BroadcastUpdatedRecordWorker).to receive(:perform_async) }

      it { expect(context).to be_a_success }
      it { expect { context }.to change { Worker.count }.by(-3) }
      it { expect { context }.not_to change { Work.count } }
      it { expect(context.event.claim.works.all? { |w| w.workers.length.zero? }).to be true }

      it 'add history to history_store' do
        [user_1, user_2, user_3].each do |u|
          expect(history_store_dbl).to receive(:add_to_combine).with(:del_workers, u.id)
        end
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
    end
  end
end
