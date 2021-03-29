require 'rails_helper'

module Histories
  RSpec.describe Storage do
    let!(:event_type) { create(:event_type, :created) }
    let(:user) { create(:admin) }
    subject { described_class.new(user) }

    describe '#add' do
      let(:history_yield_dbl) { double(:history) }
      let(:history) { instance_double('History') }
      before do
        allow(HistoryBuilder).to receive(:build).and_yield(history_yield_dbl).and_return(history)
        allow(history_yield_dbl).to receive(:set_event_type)
      end

      it 'should call HistoryBuilder with received type' do
        expect(history_yield_dbl).to receive(:set_event_type).with(:created)

        subject.add(:created)
      end

      it 'should add history to @histories array' do
        subject.add(:created)

        expect(subject.histories).to eq [history]
      end
    end

    describe '#save!' do
      let(:work) { create(:work) }
      before do
        subject.add(:created)
        subject.add(:created)
        subject.work = work
      end

      it 'should set work' do
        subject.save!

        expect(subject.histories.first.work).to eq work
      end

      it 'should set user' do
        subject.save!

        expect(subject.histories.first.user).to eq user
      end

      it { expect { subject.save! }.to change { History.count }.by(2) }
    end
  end
end
