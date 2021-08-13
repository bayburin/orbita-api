require 'rails_helper'

RSpec.describe AstraeaFormAdapter do
  let(:time) { Time.parse('2021-08-15 10:00:00') }
  let(:source_snapshot) { create(:source_snapshot) }
  let(:worker) { create(:worker) }
  let(:workflow) { create(:workflow) }
  let(:work) { create(:work) }
  let(:sd_request) { create(:sd_request, integration_id: 11, source_snapshot: source_snapshot, works: [work]) }
  let(:form) { SdRequests::CreateForm.new(sd_request) }
  let(:user) { create(:admin) }
  subject { described_class.new(form, user) }
  before { allow(Time.zone).to receive(:now).and_return(time) }

  it { expect(subject.case_id).to eq form.integration_id }
  it { expect(subject.user_id).to eq source_snapshot.tn }
  it { expect(subject.phone).to eq source_snapshot.user_attrs[:phone] }
  it { expect(subject.host_id).to eq source_snapshot.invent_num }
  it { expect(subject.barcode).to eq source_snapshot.barcode }
  it { expect(subject.desc).to eq form.description }
  it { expect(subject.rem_date).to eq form.finished_at_plan }
  it { expect(subject.rem_hour).to eq form.finished_at_plan.hour }
  it { expect(subject.rem_min).to eq form.finished_at_plan.min }
  it { expect(subject.severity).to eq form.priority }
end
