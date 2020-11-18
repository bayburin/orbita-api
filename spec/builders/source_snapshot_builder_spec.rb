require 'rails_helper'

RSpec.describe SourceSnapshotBuilder do
  include_examples 'base builder', SourceSnapshot

  describe 'instance methods' do
    let(:attr) { attributes_for(:source_snapshot, attrs: { id_tn: '12345' }) }
    subject { described_class.new }

    describe '#user_credentials=' do
      let(:user_info) { { lastName: 'last', firstName: 'first', middleName: 'middle', employeePositions: [{ personnelNo: 1, departmentForAccounting: 700 }] }.as_json }
      before do
        allow_any_instance_of(Employees::Employee).to receive(:load).with(attr[:id_tn]).and_return(user_info)
        subject.user_credentials = attr[:id_tn]
      end

      it { expect(subject.model.id_tn).to eq attr[:id_tn] }
      it { expect(subject.model.tn).to eq user_info['employeePositions'][0]['personnelNo'] }
      it { expect(subject.model.fio).to eq "#{user_info['lastName']} #{user_info['firstName']} #{user_info['middleName']}" }
      it { expect(subject.model.dept).to eq user_info['employeePositions'][0]['departmentForAccounting'] }
    end
  end
end
