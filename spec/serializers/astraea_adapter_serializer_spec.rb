require 'rails_helper'

RSpec.describe AstraeaAdapterSerializer, type: :model do
  let(:kase) { build(:astraea_kase) }
  subject { described_class.new(AstraeaAdapter.new(kase)).to_json }

  %w[id service_id service_name ticket_identity ticket_name description priority finished_at_plan comments].each do |attr|
    it "has #{attr} attribute" do
      expect(subject).to have_json_path(attr)
    end
  end

  %w[svt_item_id invent_num id_tn user_attrs].each do |attr|
    it { expect(subject).to have_json_path("source_snapshot/#{attr}") }
  end

  %w[group_id workers].each do |attr|
    it { expect(subject).to have_json_path("works/0/#{attr}") }
  end

  it { expect(subject).to have_json_path('comments/0/message') }
end
