require 'rails_helper'

module SdRequests
  RSpec.describe SourceSnapshotForm, type: :model do
    subject { described_class.new(SourceSnapshot.new) }
    let(:params) { { ss: attributes_for(:ss) } }

    describe 'validations' do
      [:id_tn, :tn].each do |attr|
        context "when #{attr} is empty" do
          before { subject.validate(Hash[attr, '']) }

          it { expect(subject.errors.messages).to include(attr) }
          it { expect(subject.errors.messages[attr]).to include('не может быть пустым') }
        end

        context "when #{attr} is not a number" do
          before { subject.validate(Hash[attr, 'test']) }

          it { expect(subject.errors.messages).to include(attr) }
          it { expect(subject.errors.messages[attr]).to include('должен быть числом') }
        end
      end

      context 'when fio is empty' do
        before { subject.validate({}) }

        it { expect(subject.errors.messages).to include(:fio) }
        it { expect(subject.errors.messages[:fio]).to include('не может быть пустым') }
      end
    end
  end
end
