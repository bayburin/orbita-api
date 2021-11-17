require 'rails_helper'

module ServiceDesk
  RSpec.describe LoadTicketData do
    let(:params) { { ticket_identity: 123 } }
    let(:body) { build(:sd_ticket) }
    let(:response_dbl) { double(:response, success?: true, body: body) }
    subject(:context) { described_class.call(params: params) }
    before { allow(ServerApi).to receive(:ticket_by_identity).and_return(response_dbl) }

    describe '.call' do
      it { expect(context).to be_a_success }
      it { expect(context.ticket).to eq Ticket.new(body) }

      context 'when ServerApi finished with error' do
        let(:body) { { error: 'test error' } }
        before { allow(response_dbl).to receive(:success?).and_return(false) }

        it { expect(context).to be_a_failure }
        it { expect(context.error).to eq body }
      end
    end
  end
end
