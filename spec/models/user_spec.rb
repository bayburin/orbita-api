require 'rails_helper'

RSpec.describe User, type: :model do
  subject { create(:admin) }

  it { is_expected.to have_many(:histories).dependent(:nullify) }
  it { is_expected.to belong_to(:role) }
  it { is_expected.to belong_to(:group).optional }

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
end
