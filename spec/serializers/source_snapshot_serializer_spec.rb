require 'rails_helper'

RSpec.describe SourceSnapshotSerializer, type: :model do
  let(:claim) { create(:claim) }
  subject { described_class.new(claim.source_snapshot).to_json }

  %w[id claim_user].each do |attr|
    it "has #{attr} attribute" do
      expect(subject).to have_json_path(attr)
    end
  end

  it 'calls ClaimUserSerializer for "claim_user" attribute' do
    expect(Oj.load(subject)['claim_user']).to eq Oj.load(ClaimUserSerializer.new(claim.source_snapshot.claim_user).to_json)
  end
end
