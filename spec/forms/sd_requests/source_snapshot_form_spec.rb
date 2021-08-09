require 'rails_helper'

module SdRequests
  RSpec.describe SourceSnapshotForm, type: :model do
    subject { described_class.new(SourceSnapshot.new) }
    let(:params) { { ss: attributes_for(:ss) } }

    describe 'validations' do
      context 'when tn is not a number' do
        before { subject.validate({ tn: 'test', fio: 'test' }) }

        it { expect(subject.errors.messages).to include(:tn) }
        it { expect(subject.errors.messages[:tn]).to include('должен быть числом') }
      end

      context 'when fio is empty' do
        before { subject.validate({}) }

        it { expect(subject.errors.messages).to include(:fio) }
        it { expect(subject.errors.messages[:fio]).to include('не может быть пустым') }
      end
    end
  end
end
