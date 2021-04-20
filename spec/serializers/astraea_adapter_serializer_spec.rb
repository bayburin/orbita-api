require 'rails_helper'

RSpec.describe AstraeaAdapterSerializer, type: :model do
  let(:kase) { build(:astraea_kase) }
  let(:current_user) { create(:manager) }
  subject { described_class.new(AstraeaAdapter.new(kase, current_user)).to_json }

  %w[integration_id service_id service_name ticket_identity ticket_name description status priority finished_at_plan].each do |attr|
    it "has #{attr} attribute" do
      expect(subject).to have_json_path(attr)
    end
  end

  %w[svt_item_id invent_num id_tn user_attrs].each do |attr|
    it { expect(subject).to have_json_path("source_snapshot/#{attr}") }
  end

  it { expect(subject).to have_json_path('works/0/group_id') }
  it { expect(subject).to have_json_path('works/0/workers/0/user_id') }
  it { expect(subject).to have_json_path('works/2/workflows/0/message') }
  it { expect(subject).to have_json_path('comments/0/message') }
end
