require 'rails_helper'

RSpec.describe EventBuilder do
  include_examples 'application builder', Event

  describe 'instance methods' do
    let(:attr) do
      Event.new(claim_id: 1, event_type: 'workflow', user_name: 'TestUser', id_tn: 12_345, payload: { message: 'Test message' }).as_json
    end
    subject { described_class.new }

    describe '#claim_id=' do
      before { subject.claim_id = attr['claim_id'] }

      it { expect(subject.model.claim_id).to eq attr['claim_id'] }
    end

    describe '#event_type=' do
      before do
        create(:event_type, :workflow)
        subject.event_type = attr['event_type']
      end

      it { expect(subject.model.event_type).to eq EventType.find_by(name: attr['event_type']) }
    end

    describe '#user_name=' do
      before { subject.user_name = attr['user_name'] }

      it { expect(subject.model.user_name).to eq attr['user_name'] }
    end

    describe '#id_tn=' do
      before { subject.id_tn = attr['id_tn'] }

      it { expect(subject.model.id_tn).to eq attr['id_tn'] }
    end

    describe '#payload=' do
      before { subject.payload = attr['payload'] }

      it { expect(subject.model.payload).to eq attr['payload'] }
    end
  end
end
