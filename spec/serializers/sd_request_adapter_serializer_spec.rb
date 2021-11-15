require 'rails_helper'

RSpec.describe SdRequestAdapterSerializer, type: :model do
  let(:kase) { build(:astraea_kase) }
  let(:current_user) { create(:manager) }
  subject { described_class.new(SdRequestAdapter.new(kase, current_user)).to_json(include: ['*', 'works.workers', 'works.workflows']) }

  %w[service_id service_name ticket_identity ticket_name description status priority finished_at_plan].each do |attr|
    it "has #{attr} attribute" do
      expect(subject).to have_json_path(attr)
    end
  end

  %w[svt_item_id barcode invent_num id_tn user_attrs].each do |attr|
    it { expect(subject).to have_json_path("source_snapshot/#{attr}") }
  end

  it { expect(subject).to have_json_path('works/0/id') }
  it { expect(subject).to have_json_path('works/0/group_id') }

  it { expect(subject).to have_json_path('works/0/workers/0/id') }
  it { expect(subject).to have_json_path('works/0/workers/0/user_id') }
  it { expect(subject).to have_json_path('works/0/workers/0/_destroy') }

  it { expect(subject).to have_json_path('works/2/workflows/0/id') }
  it { expect(subject).to have_json_path('works/2/workflows/0/message') }

  it { expect(subject).to have_json_path('comments/0/id') }
  it { expect(subject).to have_json_path('comments/0/message') }
end
