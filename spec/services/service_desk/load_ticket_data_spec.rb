require 'rails_helper'

module ServiceDesk
  RSpec.describe LoadTicketData do
    let(:ticket_identity) { 123 }
    let(:params) { { ticket_identity: ticket_identity } }
    let(:body) { { id: 1 } }
    let(:error) { { error: 'test error' } }
    let(:response_dbl) { double(:response, success?: true, body: body, error: error) }
    subject(:context) { described_class.call(params: params) }
    before { allow(Api).to receive(:ticket).and_return(response_dbl) }

    describe '.call' do
      it { expect(context).to be_a_success }
      it { expect(context.ticket).to eq Ticket.new(body) }

      context 'when Api finished with error' do
        before { allow(response_dbl).to receive(:success?).and_return(false) }

        it { expect(context).to be_a_failure }
        it { expect(context.error).to eq error }
      end
    end
  end
end
