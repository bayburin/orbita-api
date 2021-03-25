require 'rails_helper'

module SdRequests
  RSpec.describe UpdateForm, type: :model do
    let!(:sd_request) { create(:sd_request) }
    let!(:time) { Time.zone.now }
    subject do
      allow(Claim).to receive(:default_finished_at_plan).and_return(time)
      described_class.new(sd_request)
    end

    describe 'validations' do
      let(:works) { [{ group_id: 1 }, { group_id: 1 }] }
      before { subject.validate({ works: works }) }

      it { expect(subject.errors.messages).to include(:works) }
      it { expect(subject.errors.messages[:works]).to include('имеются дублирующиеся группы') }
    end
  end
end
