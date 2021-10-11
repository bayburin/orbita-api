require 'rails_helper'

module Histories
  RSpec.describe PriorityType do
    describe '#build' do
      let(:history_yield_dbl) { double(:history) }
      let(:history) { instance_double('History') }
      let(:priority) { 'new priority' }
      subject { described_class.new(priority: priority) }
      before do
        allow(HistoryBuilder).to receive(:build).and_yield(history_yield_dbl).and_return(history)
        allow(history_yield_dbl).to receive(:set_event_type)
      end

      it 'call "set_event_type" method' do
        expect(history_yield_dbl).to receive(:set_event_type).with('priority', priority: priority)

        subject.build
      end

      it 'return created history' do
        expect(subject.build).to eq history
      end
    end
  end
end
