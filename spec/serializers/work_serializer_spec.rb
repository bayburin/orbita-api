require 'rails_helper'

RSpec.describe WorkSerializer, type: :model do
  subject { described_class.new(create(:work)).to_json }

  %w[id claim_id title status attrs workers].each do |attr|
    it "has #{attr} attribute" do
      expect(subject).to have_json_path(attr)
    end
  end
end
