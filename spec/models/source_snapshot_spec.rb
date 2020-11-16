require 'rails_helper'

RSpec.describe SourceSnapshot, type: :model do
  it { is_expected.to belong_to(:claim) }

  describe '#claim_user' do
    it { expect(subject.claim_user).to be_instance_of(ClaimUser) }
  end

  describe '#claim_user=' do
    let(:id_tn) { 12_345 }
    let(:fio) { 'Test FIO' }
    let(:claim_user) { ClaimUser.new(id_tn: id_tn, fio: fio) }

    it 'should set service attributes to model attributes' do
      subject.claim_user = claim_user

      expect(subject.id_tn).to eq claim_user.id_tn
      expect(subject.fio).to eq claim_user.fio
    end
  end
end
