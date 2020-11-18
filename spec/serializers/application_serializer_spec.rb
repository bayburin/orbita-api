require 'rails_helper'

RSpec.describe ApplicationSerializer, type: :model do
  let(:application) { create(:application) }
  subject { described_class.new(application).to_json }

  it { expect(described_class).to be < ClaimSerializer }

  %w[service_id app_template_id service_name app_template_name rating].each do |attr|
    it "has #{attr} attribute" do
      expect(subject).to have_json_path(attr)
    end
  end
end
