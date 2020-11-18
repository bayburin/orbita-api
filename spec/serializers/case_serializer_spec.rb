require 'rails_helper'

RSpec.describe CaseSerializer, type: :model do
  let(:kase) { create(:case) }
  subject { described_class.new(kase).to_json }

  it { expect(described_class).to be < ClaimSerializer }
end
