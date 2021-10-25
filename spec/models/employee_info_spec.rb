require 'rails_helper'

RSpec.describe EmployeeInfo, type: :model do
  subject { build(:employee_info) }

  describe '#fio' do
    it { expect(subject.fio).to eq "#{subject.lastName} #{subject.firstName} #{subject.middleName}" }
  end

  describe '#phone' do
    it { expect(subject.phone).to eq subject.employeeContact.phone.first }
  end

  describe '#email' do
    it { expect(subject.email).to eq subject.employeeContact.email.first }
  end

  context 'when email is nil' do
    subject { build(:employee_info, employeeContact: { id: 1 }) }

    it { expect(subject.phone).to be_nil }
    it { expect(subject.email).to be_nil }
  end
end
