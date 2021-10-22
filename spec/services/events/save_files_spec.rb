require 'rails_helper'

module Events
  RSpec.describe SaveFiles do
    let!(:add_files_event_type) { create(:event_type, :add_files) }
    let(:claim) { create(:sd_request) }
    let(:work) { create(:work, claim: claim) }
    let(:files) do
      [
        ActionDispatch::Http::UploadedFile.new(
          filename: 'fake-file.txt',
          type: 'text/plain',
          tempfile: File.open(Rails.root.join('spec', 'uploads', 'test_file.txt'))
        )
      ]
    end
    let(:event_dbl) { instance_double('Event', claim: claim, work: work, files: files, payload: { is_public: true }.as_json) }
    let(:history_store_dbl) { instance_double('Histories::Storage', add_to_combine: true, save!: true) }
    let(:history_dbl) { double(:history) }
    let(:close_type_dbl) { instance_double('Histories::AddFilesType', build: history_dbl) }
    subject(:context) { described_class.call(event: event_dbl, history_store: history_store_dbl) }

    describe '.call' do
      let!(:time) { Time.parse('2020-08-20 10:00:15') }
      before do
        allow(Time.zone).to receive(:now).and_return(time)
        allow(history_store_dbl).to receive(:work=)
        allow(Histories::AddFilesType).to receive(:new).and_return(close_type_dbl)
        allow(SdRequests::BroadcastUpdatedRecordWorker).to receive(:perform_async)
      end

      it { expect(context).to be_a_success }

      it 'set finished_at attribute' do
        context

        event_dbl.claim.attachments.each do |attach|
          expect(attach.is_public).to be_truthy
        end
      end

      it 'add history to history_store' do
        files.each do |file|
          expect(history_store_dbl).to receive(:add_to_combine).with(:add_files, file.original_filename)
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

      context 'when claim was not closed' do
        let(:errors_dbl) { double(:errors, full_messages: ['error message']) }
        before do
          allow_any_instance_of(Attachment).to receive(:invalid?).and_return(true)
          allow_any_instance_of(Attachment).to receive(:errors).and_return(errors_dbl)
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
