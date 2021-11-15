require 'rails_helper'

RSpec.describe ClaimApplicationSerializer, type: :model do
  let(:claim_application) { create(:claim_application, application: build(:oauth_application), claim: build(:claim)) }
  subject { described_class.new(claim_application).to_json }

  %w[id claim_id application_id integration_id].each do |attr|
    it "has #{attr} attribute" do
      expect(subject).to have_json_path(attr)
    end
  end
end
