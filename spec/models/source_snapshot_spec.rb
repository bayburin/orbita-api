require 'rails_helper'

RSpec.describe SourceSnapshot, type: :model do
  it { is_expected.to belong_to(:claim) }

  describe '#user' do
    it { expect(subject.user).to be_instance_of(Snapshot::User) }
  end

  describe '#user=' do
    let(:user) { build(:source_snapshot_user) }
    before { subject.user = user }

    it { expect(subject.id_tn).to eq user.id_tn }
    it { expect(subject.fio).to eq user.fio }
  end

  describe '#host' do
    it { expect(subject.host).to be_instance_of(Snapshot::Host) }
  end

  describe '#host=' do
    let(:host) { build(:source_snapshot_host) }
    before { subject.host = host }

    it { expect(subject.invent_num).to eq host.invent_num }
    it { expect(subject.os).to eq host.os }
  end
end
