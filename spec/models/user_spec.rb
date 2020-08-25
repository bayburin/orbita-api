require 'rails_helper'

RSpec.describe User, type: :model do
  subject { create(:admin) }

  it { is_expected.to belong_to(:role) }
  it { is_expected.to belong_to(:group).optional }
  it { is_expected.to have_many(:histories) }

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
end
