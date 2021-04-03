require 'rails_helper'

module Events
  RSpec.describe CloseClaim do
    let!(:close_event_type) { create(:event_type, :close) }
    let(:claim) { create(:claim) }
    let(:work) { create(:work, claim: claim) }
    let(:event_dbl) { instance_double('Event', claim: claim, work: work) }
    let(:history_store_dbl) { instance_double('Histories::Storage', add: true, save!: true) }
    let(:history_dbl) { double(:history) }
    let(:close_type_dbl) { instance_double('Histories::CloseType', build: history_dbl) }
    subject(:context) { described_class.call(event: event_dbl, history_store: history_store_dbl) }

    describe '.call' do
      let!(:time) { Time.parse('2020-08-20 10:00:15') }
      before do
        allow(Time.zone).to receive(:now).and_return(time)
        allow(history_store_dbl).to receive(:work=)
        allow(Histories::CloseType).to receive(:new).and_return(close_type_dbl)
      end

      it { expect(context).to be_a_success }

      it 'set finished_at attribute' do
        context

        expect(event_dbl.claim.finished_at).to eq time
      end

      it 'add history to history_store' do
        expect(history_store_dbl).to receive(:add).with(history_dbl)

        context
      end

      it 'save history' do
        expect(history_store_dbl).to receive(:save!)

        context
      end

      context 'when claim was not closed' do
        let(:errors_dbl) { double(:errors, full_messages: ['error message']) }
        before do
          allow(claim).to receive(:save).and_return(false)
          allow(claim).to receive(:errors).and_return(errors_dbl)
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
