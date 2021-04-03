require 'rails_helper'

module Events
  RSpec.describe CreateComment do
    let!(:comment_event_type) { create(:event_type, :comment) }
    let(:claim) { create(:claim) }
    let(:work) { create(:work, claim: claim) }
    let(:message) { 'test message' }
    let(:event_dbl) do
      instance_double(
        'Event',
        event_type: comment_event_type,
        claim: claim,
        work: work,
        user: create(:manager),
        payload: { message: message }.as_json
      )
    end
    let(:history_store_dbl) { instance_double('Histories::Storage', add: true, save!: true) }
    let(:history_dbl) { double(:history) }
    let(:comment_type_dbl) { instance_double('Histories::CommentType', build: history_dbl) }
    subject(:context) { described_class.call(event: event_dbl, history_store: history_store_dbl) }

    describe '.call' do
      before do
        allow(history_store_dbl).to receive(:work=)
        allow(Histories::CommentType).to receive(:new).and_return(comment_type_dbl)
      end

      it { expect(context).to be_a_success }
      it { expect(context.comment.message).to eq message }
      it { expect(context.comment.claim_id).to eq claim.id }

      it 'add history to history_store' do
        expect(history_store_dbl).to receive(:add).with(history_dbl)

        context
      end

      it 'save history' do
        expect(history_store_dbl).to receive(:save!)

        context
      end

      context 'when comment was not saved' do
        let(:errors_dbl) { double(:errors, full_messages: ['error message']) }
        before do
          allow_any_instance_of(Comment).to receive(:save).and_return(false)
          allow_any_instance_of(Comment).to receive(:errors).and_return(errors_dbl)
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
