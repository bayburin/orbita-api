require 'rails_helper'

RSpec.describe RoleSerializer, type: :model do
  subject { described_class.new(create(:admin_role)).to_json }

  %w[id name description].each do |attr|
    it "has #{attr} attribute" do
      expect(subject).to have_json_path(attr)
    end
  end
end
