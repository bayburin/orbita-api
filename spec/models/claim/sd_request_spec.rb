require 'rails_helper'

RSpec.describe SdRequest, type: :model do
  it { is_expected.to be_kind_of Claim }

  describe '#ticket' do
    it { expect(subject.ticket).to be_instance_of(ServiceDesk::Ticket) }
  end

  describe '#ticket=' do
    let(:ticket) { build(:sd_ticket) }
    before { subject.ticket = ticket }

    it { expect(subject.ticket_identity).to eq ticket.identity }
    it { expect(subject.ticket_name).to eq ticket.name }
    it { expect(subject.service_id).to eq ticket.service.id }
    it { expect(subject.service_name).to eq ticket.service.name }
  end
end
