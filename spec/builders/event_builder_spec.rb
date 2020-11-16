require 'rails_helper'

RSpec.describe EventBuilder do
  include_examples 'base builder', Event

  describe 'instance methods' do
    let!(:claim) { create(:claim) }
    let!(:user) { create(:admin) }
    let(:event_type) { create(:event_type, :workflow) }
    let(:attr) do
      { claim_id: claim.id, event_type: event_type.name, id_tn: user.id_tn, payload: { message: 'Test message' } }.as_json
    end
    subject { described_class.new }

    describe '#claim_id=' do
      before { subject.claim_id = attr['claim_id'] }

      it { expect(subject.model.claim).to eq claim }
    end

    describe '#claim=' do
      before { subject.claim = claim }

      it { expect(subject.model.claim).to eq claim }
    end

    describe '#event_type=' do
      before { subject.event_type = attr['event_type'] }

      it { expect(subject.model.event_type).to eq event_type }
    end

    describe '#id_tn=' do
      before { subject.id_tn = attr['id_tn'] }

      it { expect(subject.model.user).to eq user }
    end

    describe '#payload=' do
      before { subject.payload = attr['payload'] }

      it { expect(subject.model.payload).to eq attr['payload'] }
    end
  end
end
