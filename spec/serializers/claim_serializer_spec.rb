require 'rails_helper'

RSpec.describe ClaimSerializer, type: :model do
  let(:claim) { create(:claim) }
  subject { described_class.new(claim).to_json }

  %w[id type description status priority runtime parameter works source_snapshot comments].each do |attr|
    it "has #{attr} attribute" do
      expect(subject).to have_json_path(attr)
    end
  end

  it 'calls RuntimeSerializer for "runtime" attribute' do
    expect(Oj.load(subject)['runtime']).to eq Oj.load(RuntimeSerializer.new(claim.runtime).to_json)
  end
end
