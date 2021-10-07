require 'rails_helper'

module SdRequests
  RSpec.describe NotifyOnUpdate do
    let(:sd_request) { create(:sd_request) }
    let(:history_store_dbl) { instance_double('Histories::Storage', histories: []) }
    subject(:context) { described_class.call(sd_request: sd_request, history_store: history_store_dbl) }

    describe '.call' do
      it { expect(context).to be_a_success }

      it 'call SdRequests::UpdatedWorker worker if history_store is empty' do
        expect(SdRequests::UpdatedWorker).not_to receive(:perform_async).with(sd_request.id)

        context
      end

      context 'when history_store has any history' do
        before { allow(history_store_dbl).to receive(:histories).and_return([1, 2]) }

        it 'call SdRequests::UpdatedWorker worker' do
          expect(SdRequests::UpdatedWorker).to receive(:perform_async).with(sd_request.id)

          context
        end

        it 'call BroadcastUpdatedRecordWorker worker' do
          expect(BroadcastUpdatedRecordWorker).to receive(:perform_async).with(sd_request.id)

          context
        end
      end
    end
  end
end
