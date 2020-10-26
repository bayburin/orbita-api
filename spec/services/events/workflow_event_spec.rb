require 'rails_helper'

module Events
  RSpec.describe WorkflowEvent do
    let(:user) { create(:admin) }
    let(:claim) { create(:claim) }
    let(:payload) { { message: 'Test payload message' }.as_json }
    let(:event) { double(:event, claim_id: claim.id, id_tn: user.id_tn, payload: payload) }
    subject(:context) { described_class.call(event: event) }

    describe '.call' do
      it { expect(context).to be_a_success }

      it_behaves_like 'requirementable'
    end
  end
end
