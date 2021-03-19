require 'rails_helper'

RSpec.describe SdRequest, type: :model do
  it { is_expected.to be_kind_of Claim }

  describe '#ticket' do
    it { expect(subject.ticket).to be_instance_of(ServiceDesk::Ticket) }
  end

  describe '#ticket=' do
    let(:ticket_identity) { 1 }
    let(:ticket_name) { 'test-ticket-name' }
    let(:service_id) { 2 }
    let(:service_name) { 'test-service-name' }
    let(:ticket) do
      ServiceDesk::Ticket.new(
        identity: ticket_identity,
        name: ticket_name,
        service: { id: service_id, name: service_name }
      )
    end
    before { subject.ticket = ticket }

    it { expect(subject.ticket_identity).to eq ticket_identity }
    it { expect(subject.ticket_name).to eq ticket_name }
    it { expect(subject.service_id).to eq service_id }
    it { expect(subject.service_name).to eq service_name }
  end
end
