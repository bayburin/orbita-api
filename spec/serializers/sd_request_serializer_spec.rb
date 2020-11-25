require 'rails_helper'

RSpec.describe SdRequestSerializer, type: :model do
  let(:sd_request) { create(:sd_request) }
  subject { described_class.new(sd_request).to_json }

  it { expect(described_class).to be < ClaimSerializer }

  %w[service_id app_template_id service_name app_template_name rating].each do |attr|
    it "has #{attr} attribute" do
      expect(subject).to have_json_path(attr)
    end
  end
end
