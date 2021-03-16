require 'rails_helper'

RSpec.describe User, type: :model do
  subject { create(:admin) }

  it { is_expected.to have_many(:histories).dependent(:nullify) }
  it { is_expected.to belong_to(:role) }
  it { is_expected.to belong_to(:group).optional }

  describe '.authenticate_employee' do
    let!(:employee) { create(:employee) }
    let(:id_tn) { 123321 }
    let(:user_info) { { id: id_tn } }
    let(:employee_dbl) { double(:employee) }
    subject { described_class.authenticate_employee(id_tn) }
    before do
      allow(User).to receive(:find_by).and_return(employee)
      allow(employee).to receive(:fill_by_employee)
      allow_any_instance_of(Employees::Loader).to receive(:load).and_return(user_info)
      allow(Employee).to receive(:new).with(user_info).and_return(employee_dbl)
    end

    it { expect(subject.id).to eq employee.id }

    context 'when user not found' do
      before { allow(User).to receive(:find_by).and_return(nil) }

      it { expect(subject).to be_nil }

      it 'does not call Employees::Loader' do
        expect_any_instance_of(Employees::Loader).not_to receive(:load)

        subject
      end
    end

    it 'call Employees::Loader' do
      expect_any_instance_of(Employees::Loader).to receive(:load).with(id_tn)

      subject
    end

    context 'when Employees::Loader return nil' do
      before { expect_any_instance_of(Employees::Loader).to receive(:load).and_return(nil)  }

      it { expect { subject }.to raise_error(RuntimeError) }
    end

    it 'call #fill_by_employee method' do
      expect(employee).to receive(:fill_by_employee).with(employee_dbl)

      subject
    end
  end

  describe '#role?' do
    it 'return true if user has received role' do
      expect(subject.role?(:admin)).to be_truthy
    end

    context 'when user has another role' do
      subject { create(:manager) }

      it 'return false' do
        expect(subject.role?(:admin)).to be_falsey
      end
    end
  end

  describe '#one_of_roles?' do
    it 'return true if user has one of received roles' do
      expect(subject.one_of_roles?(:admin, :manager)).to be_truthy
    end

    context 'when user has another role' do
      it 'return false' do
        expect(subject.one_of_roles?(:manager, :test)).to be_falsey
      end
    end
  end

  describe '#belongs_to_claim?' do
    let(:claim) { create(:sd_request) }
    let!(:work) { create(:work, claim: claim) }

    it { expect(subject.belongs_to_claim?(claim)).to be_falsey }

    it 'return true if user belongs to claim' do
      work.users << subject

      expect(subject.belongs_to_claim?(claim)).to be_truthy
    end
  end

  describe '#fill_by_employee' do
    let(:attrs) { attributes_for(:admin) }
    let(:positions) { [double(:position, personnelNo: attrs[:tn])] }
    let(:contact) { double(:contact, login: attrs[:login], phone: [attrs[:work_tel]], email: [attrs[:email]]) }
    let(:employee) { double(:employee, id: attrs[:id_tn], employeePositions: positions, employeeContact: contact, fio: attrs[:fio]) }
    subject { described_class.new }
    before { subject.fill_by_employee(employee) }

    it { expect(subject.tn).to eq attrs[:tn] }
    it { expect(subject.id_tn).to eq attrs[:id_tn] }
    it { expect(subject.login).to eq attrs[:login] }
    it { expect(subject.fio).to eq attrs[:fio] }
    it { expect(subject.work_tel).to eq attrs[:work_tel] }
    it { expect(subject.email).to eq attrs[:email] }
  end
end
