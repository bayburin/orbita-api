require 'rails_helper'

RSpec.describe Claim, type: :model do
  it { is_expected.to have_many(:works).dependent(:destroy) }
  it { is_expected.to have_many(:workers).through(:works).dependent(:destroy) }
  it { is_expected.to have_many(:users).through(:workers).dependent(:destroy) }
  it { is_expected.to have_many(:comments).dependent(:destroy) }
  it { is_expected.to have_many(:attachments).dependent(:destroy) }
  it { is_expected.to have_many(:parameters).dependent(:destroy) }
  it { is_expected.to belong_to(:application).optional.class_name('Doorkeeper::Application') }

  describe '.default_finished_at_plan' do
    let!(:time) { Time.parse('2020-08-20 10:00:15') }
    before { allow(Time.zone).to receive(:now).and_return(time) }

    it 'set +3 days to finished_at_plan attribute' do
      expect(described_class.default_finished_at_plan).to eq Time.zone.now + 3.days
    end
  end

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
    let(:runtime) { build(:runtime, finished_at_plan: finished_at_plan) }
    before { allow(Time.zone).to receive(:now).and_return(time) }

    it 'should set service attributes to model attributes' do
      subject.runtime = runtime

      expect(subject.finished_at_plan).to eq finished_at_plan
      expect(subject.finished_at).to eq runtime.finished_at
    end
  end

  describe '#work_for' do
    let!(:work_1) { create(:work, claim: subject) }
    let!(:work_2) { create(:work, claim: subject) }
    let!(:user) { create(:admin) }

    it { expect(subject.work_for(user)).to be_nil }

    it 'return work which belongs to user' do
      work_1.users << user

      expect(subject.work_for(user)).to eq work_1
    end
  end
end
