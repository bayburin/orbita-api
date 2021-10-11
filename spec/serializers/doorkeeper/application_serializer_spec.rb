require 'rails_helper'

RSpec.describe Doorkeeper::ApplicationSerializer, type: :model do
  let(:app) { create(:oauth_application) }
  subject { described_class.new(app).to_json }

  %w[id name].each do |attr|
    it "has #{attr} attribute" do
      expect(subject).to have_json_path(attr)
    end
  end
end
