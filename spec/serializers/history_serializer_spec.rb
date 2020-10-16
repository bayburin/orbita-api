require 'rails_helper'

RSpec.describe HistorySerializer, type: :model do
  subject { described_class.new(create(:history)).to_json }

  %w[id work_id user_id action action_type created_at].each do |attr|
    it "has #{attr} attribute" do
      expect(subject).to have_json_path(attr)
    end
  end
end
