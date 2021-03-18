require 'rails_helper'

RSpec.describe SdRequestBuilder do
  include_examples 'base builder', SdRequest

  describe 'instance methods' do
    let(:attr) { attributes_for(:sd_request, attrs: { foo: :bar }) }
    subject { described_class.new }

    describe '#service_id=' do
      before { subject.service_id = attr[:service_id] }

      it { expect(subject.model.service_id).to eq attr[:service_id] }
    end

    describe '#service_name=' do
      before { subject.service_name = attr[:service_name] }

      it { expect(subject.model.service_name).to eq attr[:service_name] }
    end

    describe '#set_service' do
      let(:service) { ServiceDesk::Service.new(id: attr[:service_id], name: attr[:service_name]) }
      before { subject.set_service(attr[:service_id], attr[:service_name]) }

      it { expect(subject.model.service).to eq service }
    end

    describe '#ticket_identity=' do
      before { subject.ticket_identity = attr[:ticket_identity] }

      it { expect(subject.model.ticket_identity).to eq attr[:ticket_identity] }
    end

    describe '#ticket_name=' do
      before { subject.ticket_name = attr[:ticket_name] }

      it { expect(subject.model.ticket_name).to eq attr[:ticket_name] }
    end

    describe '#set_ticket' do
      let(:ticket) { ServiceDesk::Ticket.new(id: attr[:ticket_identity], name: attr[:ticket_name]) }
      before { subject.set_ticket(attr[:ticket_identity], attr[:ticket_name]) }

      it { expect(subject.model.ticket).to eq ticket }
    end

    describe '#status=' do
      before { subject.status = attr[:status] }

      it { expect(subject.model.status).to eq attr[:status] }
    end

    describe '#attrs=' do
      before { subject.attrs = attr[:attrs] }

      it { expect(subject.model.attrs).to eq attr[:attrs].as_json }
    end

    describe '#rating=' do
      before { subject.attrs = attr[:rating] }

      it { expect(subject.model.rating).to eq attr[:rating] }
    end

    describe '#set_runtime' do
      before { subject.set_runtime(attr[:finished_at_plan], attr[:finished_at]) }

      it { expect(subject.model.runtime).to be_instance_of(Runtime) }
    end
  end
end
