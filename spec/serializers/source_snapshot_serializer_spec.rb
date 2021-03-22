require 'rails_helper'

RSpec.describe SourceSnapshotSerializer, type: :model do
  let(:claim) { create(:claim) }
  subject { described_class.new(claim.source_snapshot).to_json }

  %w[id user host].each do |attr|
    it "has #{attr} attribute" do
      expect(subject).to have_json_path(attr)
    end
  end

  it 'calls Snapshot::UserSerializer for "user" attribute' do
    expect(Oj.load(subject)['user']).to eq Oj.load(Snapshot::UserSerializer.new(claim.source_snapshot.user).to_json)
  end

  it 'calls Snapshot::HostSerializer for "host" attribute' do
    expect(Oj.load(subject)['host']).to eq Oj.load(Snapshot::HostSerializer.new(claim.source_snapshot.host).to_json)
  end
end
