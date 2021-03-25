require 'rails_helper'

RSpec.describe WorkForm, type: :model do
  subject { described_class.new(Work.new) }
  let(:params) { { work: attributes_for(:work) } }

  describe 'validations' do
    context 'when group_id is empty' do
      before { subject.validate({ group_id: '' }) }

      it { expect(subject.errors.messages).to include(:group_id) }
      it { expect(subject.errors.messages[:group_id]).to include('не может быть пустым') }
    end

    context 'when group_id is not a number' do
      before { subject.validate({ group_id: 'test' }) }

      it { expect(subject.errors.messages).to include(:group_id) }
      it { expect(subject.errors.messages[:group_id]).to include('должен быть числом') }
    end

    context 'when its a new object, but such group_id already exist' do
      let!(:work) { create(:work) }
      before { subject.validate({ claim_id: work.claim_id, group_id: work.group_id }) }

      it { expect(subject.errors.messages).to include(:group_id) }
    end
  end
end
