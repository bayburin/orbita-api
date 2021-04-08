require 'rails_helper'

RSpec.describe SourceSnapshotBuilder do
  include_examples 'base builder', SourceSnapshot

  describe 'instance methods' do
    let(:attr) { attributes_for(:source_snapshot, attrs: { id_tn: '12345', invent_num: '12345' }) }
    subject { described_class.new }

    describe '#user_credentials=' do
      let(:user_info) { build(:employee_info).as_json }
      before do
        allow_any_instance_of(Employees::Loader).to receive(:load).with(attr[:id_tn]).and_return(user_info)
        subject.user_credentials = attr[:id_tn]
      end

      it { expect(subject.model.id_tn).to eq attr[:id_tn] }
      it { expect(subject.model.tn).to eq user_info['employeePositions'].first['personnelNo'] }
      it { expect(subject.model.fio).to eq "#{user_info['lastName']} #{user_info['firstName']} #{user_info['middleName']}" }
      it { expect(subject.model.dept).to eq user_info['employeePositions'].first['departmentForAccounting'] }
    end

    describe '#host_credentials=' do
      let(:user) { create(:admin) }
      let(:host_info) { attributes_for(:source_snapshot_host) }
      let(:host_info_loader_dbl) { double(:host_info_loader, load: host_info) }
      before { allow(AuthCenter::HostInfoLoader).to receive(:new).and_return(host_info_loader_dbl) }

      context 'when when AuthCenter::AppToken finished successfully' do
        it 'call "host_info" method' do
          expect(host_info_loader_dbl).to receive(:load)

          subject.host_credentials = attr[:invent_num]
        end

        context 'compare attrs' do
          before { subject.host_credentials = attr[:invent_num] }

          it { expect(subject.model.dns).to eq host_info['name'] }
          it { expect(subject.model.source_ip).to eq host_info['ip'] }
          it { expect(subject.model.mac).to eq host_info['mac'] }
          it { expect(subject.model.os).to eq host_info['os'] }
        end
      end

      context 'when AuthCenter::AppToken failed' do
        before do
          allow(host_info_loader_dbl).to receive(:load).and_return(nil)
          subject.host_credentials = attr[:invent_num]
        end

        it { expect(subject.model.dns).to be_nil }
        it { expect(subject.model.source_ip).to be_nil }
        it { expect(subject.model.mac).to be_nil }
        it { expect(subject.model.os).to be_nil }
      end
    end
  end
end
