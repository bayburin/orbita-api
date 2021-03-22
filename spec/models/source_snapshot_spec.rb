require 'rails_helper'

RSpec.describe SourceSnapshot, type: :model do
  it { is_expected.to belong_to(:claim) }

  describe '#user' do
    it { expect(subject.user).to be_instance_of(Snapshot::User) }
  end

  describe '#user=' do
    let(:id_tn) { 12_345 }
    let(:fio) { 'Test FIO' }
    let(:user) { Snapshot::User.new(id_tn: id_tn, fio: fio) }
    before { subject.user = user }

    it { expect(subject.id_tn).to eq user.id_tn }
    it { expect(subject.fio).to eq user.fio }
  end

  describe '#host' do
    it { expect(subject.host).to be_instance_of(Snapshot::Host) }
  end

  describe '#host=' do
    let(:invent_num) { 12_345 }
    let(:os) { 'Test OS' }
    let(:host) { Snapshot::Host.new(invent_num: invent_num, os: os) }
    before { subject.host = host }

    it { expect(subject.invent_num).to eq host.invent_num }
    it { expect(subject.os).to eq host.os }
  end
end
