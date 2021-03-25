require 'rails_helper'

module SdRequests
  RSpec.describe UpdateForm, type: :model do
    let!(:sd_request) { create(:sd_request) }
    let!(:time) { Time.zone.now }
    subject do
      allow(Claim).to receive(:default_finished_at_plan).and_return(time)
      described_class.new(sd_request)
    end

    it { expect(described_class).to be < SdRequestForm }
  end
end
