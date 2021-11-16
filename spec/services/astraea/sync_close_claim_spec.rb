require 'rails_helper'

module Astraea
  RSpec.describe SyncCloseClaim do
    let(:admin) { create(:admin) }
    let!(:sd_request) { create(:sd_request) }
    let!(:claim_application) { create(:claim_application, claim: sd_request, integration_id: 123, application: create(:oauth_application, name: 'Astraea')) }
    let(:event_dbl) { double(:event, claim: sd_request, user: admin) }
    before { allow(CloseCaseWorker).to receive(:perform_async) }
    subject(:context) { described_class.call(event: event_dbl, need_update_astraea: true) }

    describe '.call' do
      it { expect(context).to be_a_success }

      it 'call CloseCaseWorker worker' do
        expect(CloseCaseWorker).to receive(:perform_async).with(123, admin.tn)

        context
      end

      context 'when need_update_astraea is undefined' do
        subject(:context) { described_class.call(event: event_dbl) }

        it 'does not call CloseCaseWorker worker' do
          expect(CloseCaseWorker).not_to receive(:perform_async).with(sd_request.integration_id, admin.tn)

          context
        end
      end
    end
  end
end
