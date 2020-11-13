require 'rails_helper'

RSpec.describe ClaimSerializer, type: :model do
  let(:claim) { create(:claim) }
  subject { described_class.new(claim).to_json }

  %w[id service_id app_template_id service_name app_template_name status priority attrs rating runtime claim_user].each do |attr|
    it "has #{attr} attribute" do
      expect(subject).to have_json_path(attr)
    end
  end

  it 'calls RuntimeSerializer for "runtime" attribute' do
    expect(Oj.load(subject)['runtime']).to eq Oj.load(RuntimeSerializer.new(claim.runtime).to_json)
  end

  it 'calls ClaimUserSerializer for "claim_user" attribute' do
    expect(Oj.load(subject)['claim_user']).to eq Oj.load(ClaimUserSerializer.new(claim.claim_user).to_json)
  end
end
