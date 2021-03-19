require 'rails_helper'

module SdRequests
  RSpec.describe BuildFromEvent do
    let(:sd_request) { build(:sd_request) }
    let(:sd_request_dbl) { double(:sd_request) }
    let(:ticket) do
      ServiceDesk::Ticket.new(
        identity: 1,
        name: 'ticket-name',
        service: {
          id: 2,
          name: 'service-name'
        }
      )
    end
    let(:id_tn) { 1234 }
    subject(:context) { described_class.call(ticket: ticket, params: { id_tn: id_tn }) }
    before do
      allow(SdRequestBuilder).to receive(:build).and_yield(sd_request_dbl).and_return(sd_request)
      allow(sd_request_dbl).to receive(:ticket=)
    end

    describe '.call' do
      it { expect(context).to be_a_success }
      it { expect(context.sd_request).to be_instance_of(SdRequest) }

      it 'set ticket' do
        expect(sd_request_dbl).to receive(:ticket=).with(ticket)

        context
      end

      it { expect(context.params[:source_snapshot][:id_tn]).to eq id_tn }
    end
  end
end
