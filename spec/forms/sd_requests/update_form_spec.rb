require 'rails_helper'

module SdRequests
  RSpec.describe UpdateForm, type: :model do
    create_event_types

    let!(:sd_request) { create(:sd_request) }
    let!(:time) { Time.zone.now }
    let(:history_store_dbl) { instance_double('Histories::Storage', add: true) }
    let(:params) do
      attributes_for(:sd_request).merge(
        priority: 'low',
        finished_at_plan: (Time.zone.now + 5.days).to_s
      )
    end
    subject do
      allow(Claim).to receive(:default_finished_at_plan).and_return(time)
      described_class.new(sd_request).tap do |form|
        form.history_store = history_store_dbl
        form.current_user = create(:employee)
      end
    end

    it { expect(described_class).to be < SdRequestForm }

    describe '#processing_history' do
      let(:history_postpone_dbl) { instance_double(History) }
      let(:history_priority_dbl) { instance_double(History) }
      before do
        allow_any_instance_of(Histories::PostponeType).to receive(:build).and_return(history_postpone_dbl)
        allow_any_instance_of(Histories::PriorityType).to receive(:build).and_return(history_priority_dbl)
      end

      it 'add created "postpone" history to history_store' do
        expect(history_store_dbl).to receive(:add).with(history_postpone_dbl)

        subject.validate(params)
      end

      it 'add created "priority" history to history_store' do
        expect(history_store_dbl).to receive(:add).with(history_priority_dbl)

        subject.validate(params)
      end
    end
  end
end
