require 'rails_helper'

RSpec.describe User, type: :model do
  subject { create(:admin) }

  it { is_expected.to have_many(:histories).dependent(:nullify) }
  it { is_expected.to belong_to(:role) }
  it { is_expected.to belong_to(:group).optional }

  describe '.authenticate_employee' do
    let!(:employee) { create(:employee) }
    let(:id_tn) { 123_321 }
    let(:user_info) { { id: id_tn } }
    let(:employee_dbl) { double(:employee) }
    subject { described_class.authenticate_employee(id_tn) }
    before do
      allow(User).to receive(:find_by).and_return(employee)
      allow(employee).to receive(:fill_by_employee_info)
      allow_any_instance_of(Employees::Loader).to receive(:load).and_return(user_info)
      allow(EmployeeInfo).to receive(:new).with(user_info).and_return(employee_dbl)
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
      before { expect_any_instance_of(Employees::Loader).to receive(:load).and_return(nil) }

      it { expect { subject }.to raise_error(RuntimeError) }
    end

    it 'call #fill_by_employee_info method' do
      expect(employee).to receive(:fill_by_employee_info).with(employee_dbl)

      subject
    end
  end

  describe '.employee_user' do
    let!(:admin) { create(:admin) }
    let!(:employee) { create(:employee) }
    let(:subject) { described_class }

    it { expect(subject.employee_user).to eq employee }
  end

  describe '#fio_initials' do
    before { subject.fio = 'Тестовый Важный Пользователь' }

    it { expect(subject.fio_initials).to eq 'Тестовый В.П.' }
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

  describe '#fill_by_employee_info' do
    let(:employee_info) { build(:employee_info) }
    subject { described_class.new }
    before { subject.fill_by_employee_info(employee_info) }

    it { expect(subject.tn).to eq employee_info.employeePositions.first.personnelNo }
    it { expect(subject.id_tn).to eq employee_info.id }
    it { expect(subject.login).to eq employee_info.employeeContact.login }
    it { expect(subject.fio).to eq employee_info.fio }
    it { expect(subject.work_tel).to eq employee_info.first_phone }
    it { expect(subject.email).to eq employee_info.first_email }
  end
end
