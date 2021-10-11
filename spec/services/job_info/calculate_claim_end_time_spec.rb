require 'rails_helper'

module JobInfo
  RSpec.describe CalculateClaimEndTime, type: :model do
    let(:tn) { 123 }
    let(:start_time) { Time.zone.now }
    let(:hours) { 15 }
    let!(:new_time) { Time.parse('2021-08-14 15:05:36') }
    let(:response_dbl) { double('response', success?: true, body: { data: new_time }.as_json) }
    subject { described_class.new(tn, start_time, hours) }
    before { allow(Api).to receive(:claim_end_time).and_return(response_dbl) }

    describe '#calculate' do
      it 'call Api.claim_end_time method' do
        expect(Api).to receive(:claim_end_time).with(tn, start_time, hours)

        subject.calculate
      end

      it { expect(subject.calculate).to eq new_time }

      context 'when Api.claim_end_time finished with error' do
        before { allow(response_dbl).to receive(:success?).and_return(false) }

        it { expect(subject.calculate).to be_nil }
      end
    end
  end
end
