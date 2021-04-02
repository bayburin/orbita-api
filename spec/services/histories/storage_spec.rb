require 'rails_helper'

module Histories
  RSpec.describe Storage do
    create_event_types

    let(:user) { create(:admin) }
    let(:history) { build(:history, :workflow) }
    subject { described_class.new(user) }

    describe '#add_to_combine' do
      [:add_workers, :del_workers].each do |type|
        it "add payload to @tmp[#{type}] array" do
          subject.add_to_combine(type, user.id)

          expect(subject.instance_variable_get(:@tmp)[type]).to include(user.id)
        end
      end
    end

    describe '#add' do
      it 'add history to @histories array' do
        subject.add(history)

        expect(subject.histories).to eq [history]
      end
    end

    describe '#save!' do
      let(:work) { create(:work) }
      before do
        subject.add(history)
        subject.add(build(:history, :workflow))
        subject.add(build(:history, :created))
        subject.work = work
      end

      it 'set work' do
        subject.save!

        expect(subject.histories.first.work).to eq work
      end

      it 'set user' do
        subject.save!

        expect(subject.histories.first.user).to eq user
      end

      it 'sort histories by EventType' do
        subject.save!

        expect(subject.histories.first.event_type).to eq EventType.find_by(name: :created)
      end

      it { expect { subject.save! }.to change { History.count }.by(3) }

      context 'when storage has @worker_history object' do
        let(:add_user) { create(:manager) }
        let(:del_user) { create(:manager) }
        let(:add_workers_type) { EventType.find_by(name: :add_workers) }
        let(:del_workers_type) { EventType.find_by(name: :del_workers) }
        before do
          subject.add_to_combine(:add_workers, user.id)
          subject.add_to_combine(:add_workers, add_user.id)
          subject.add_to_combine(:del_workers, del_user.id)
        end

        it 'create one history with added users' do
          subject.save!

          expect(subject.histories.select { |hist| hist.event_type_id == add_workers_type.id }.count).to eq 1
        end

        it 'create one history with removed users' do
          subject.save!

          expect(subject.histories.select { |hist| hist.event_type_id == del_workers_type.id }.count).to eq 1
        end

        it { expect { subject.save! }.to change { History.count }.by(5) }
      end
    end
  end
end
