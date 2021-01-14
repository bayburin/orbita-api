require 'rails_helper'

RSpec.describe Claim, type: :model do
  it { is_expected.to have_many(:works).dependent(:destroy) }
  it { is_expected.to have_many(:comments).dependent(:destroy) }
  it { is_expected.to have_many(:attachments).dependent(:destroy) }

  describe '#find_or_initialize_work_by_user' do
    let(:user) { create(:admin) }

    it 'return new work' do
      expect(subject.find_or_initialize_work_by_user(user)).to be_instance_of(Work)
    end

    it 'set group_id from user group' do
      expect(subject.find_or_initialize_work_by_user(user).group_id).to eq(user.group_id)
    end

    context 'when work exists' do
      let!(:work) { create(:work, group: user.group, claim: subject) }

      it 'return work which includes user' do
        expect(subject.find_or_initialize_work_by_user(user)).to eq(work)
      end
    end
  end

  describe '#runtime' do
    it { expect(subject.runtime).to be_instance_of(Runtime) }
  end

  describe '#runtime=' do
    let!(:time) { Time.parse('2020-08-20 10:00:15') }
    let(:finished_at_plan) { Time.zone.now - 2.days }
    let(:finished_at) { Time.zone.now }
    let(:runtime) { Runtime.new(finished_at_plan: finished_at_plan, finished_at: finished_at) }
    before { allow(Time.zone).to receive(:now).and_return(time) }

    it 'should set service attributes to model attributes' do
      subject.runtime = runtime

      expect(subject.finished_at_plan).to eq runtime.finished_at_plan
      expect(subject.finished_at).to eq runtime.finished_at
    end
  end
end
