require 'rails_helper'

RSpec.describe SdRequest, type: :model do
  it { is_expected.to be_kind_of Claim }

  describe '#service' do
    it { expect(subject.service).to be_instance_of(ServiceDesk::Service) }
  end

  describe '#service=' do
    let(:id) { 1 }
    let(:name) { 'test name' }
    let(:service) { ServiceDesk::Service.new(id: id, name: name) }

    it 'should set service attributes to model attributes' do
      subject.service = service

      expect(subject.service_id).to eq service.id
      expect(subject.service_name).to eq service.name
    end
  end

  describe '#ticket' do
    it { expect(subject.ticket).to be_instance_of(ServiceDesk::Ticket) }
  end

  describe '#ticket=' do
    let(:id) { 1 }
    let(:name) { 'test name' }
    let(:ticket) { ServiceDesk::Ticket.new(id: id, name: name) }

    it 'should set service attributes to model attributes' do
      subject.ticket = ticket

      expect(subject.ticket_identity).to eq ticket.id
      expect(subject.ticket_name).to eq ticket.name
    end
  end
end
