require 'rails_helper'

RSpec.describe ClaimApplication, type: :model do
  it { is_expected.to belong_to(:application).class_name('Doorkeeper::Application') }
  it { is_expected.to belong_to(:claim) }

  describe 'validate unique_application_claim' do
    let(:app) { create(:oauth_application) }
    let(:claim) { build(:claim, ticket_identity: 1) }

    context 'when claim with specified ticket_identity, application_id and integration_id already exist' do
      let(:created_claim) { create(:claim, ticket_identity: 1) }
      let!(:claim_applications) { create(:claim_application, claim: claim, application_id: app.id, integration_id: 3) }
      subject { build(:claim_application, claim: claim, application_id: app.id, integration_id: 3) }
      before { subject.valid? }

      it { expect(subject).not_to be_valid }
      it { expect(subject.errors.details[:integration_id]).to include(error: :taken) }
    end

    context 'in another case' do
      subject { build(:claim_application, claim: claim, application_id: app.id, integration_id: 3) }

      it { expect(subject).to be_valid }
    end
  end
end
