require 'rails_helper'

module Histories
  RSpec.describe Storage do
    let(:history) { build(:history) }
    let(:user) { create(:admin) }
    subject { described_class.new(user) }

    describe '#add' do
      it 'should add history to @histories array' do
        subject.add(history)

        expect(subject.histories).to eq [history]
      end
    end

    describe '#save!' do
      let(:work) { create(:work) }
      let(:new_history) { build(:history) }
      before do
        subject.add(history)
        subject.add(new_history)
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
