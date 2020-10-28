require 'rails_helper'

module Events
  RSpec.describe CloseClaim do
    let(:claim) { create(:claim) }
    let(:event_dbl) { double(:event, claim: claim) }
    subject(:context) { described_class.call(event: event_dbl) }

    describe '.call' do
      let!(:time) { Time.parse('2020-08-20 10:00:15') }
      before { allow(Time.zone).to receive(:now).and_return(time) }

      it { expect(context).to be_a_success }
      it { expect(context.claim.finished_at).to eq time }

      context 'when claim was not closed' do
        let(:errors_dbl) { double(:errors, full_messages: ['error message']) }
        before do
          allow(claim).to receive(:update).and_return(false)
          allow(claim).to receive(:errors).and_return(errors_dbl)
        end

        it { expect(context).to be_a_failure }
        it { expect(context.error).to eq errors_dbl.full_messages }
      end
    end
  end
end
