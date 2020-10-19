require 'rails_helper'

RSpec.describe ClaimForm, type: :model do
  subject { described_class.new(Claim.new) }
  let(:params) { { claim: attributes_for(:claim) } }
end
