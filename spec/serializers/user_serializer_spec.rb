require 'rails_helper'

RSpec.describe UserSerializer, type: :model do
  subject { described_class.new(create(:admin)).to_json }

  %w[id role_id tn id_tn fio work_tel mobile_tel email is_vacation].each do |attr|
    it "has #{attr} attribute" do
      expect(subject).to have_json_path(attr)
    end
  end
end
