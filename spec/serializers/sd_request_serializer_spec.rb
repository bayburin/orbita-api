require 'rails_helper'

RSpec.describe SdRequestSerializer, type: :model do
  let(:sd_request) { create(:sd_request) }
  subject { described_class.new(sd_request).to_json }

  it { expect(described_class).to be < ClaimSerializer }

  %w[integration_id application_id service_id ticket_identity service_name ticket_name rating].each do |attr|
    it "has #{attr} attribute" do
      expect(subject).to have_json_path(attr)
    end
  end
end
