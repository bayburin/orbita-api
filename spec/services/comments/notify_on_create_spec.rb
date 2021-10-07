require 'rails_helper'

module Comments
  RSpec.describe NotifyOnCreate do
    let(:claim) { create(:claim) }
    let(:comment) { create(:comment, claim: claim) }
    subject(:context) { described_class.call(claim: claim, comment: comment) }

    describe '.call' do
      it 'call SendCommentWorker worker' do
        expect(SendCommentWorker).to receive(:perform_async).with(claim.id, comment.id)

        context
      end
    end
  end
end
