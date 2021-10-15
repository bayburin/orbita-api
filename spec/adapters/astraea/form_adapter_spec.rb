require 'rails_helper'

module Astraea
  RSpec.describe FormAdapter do
    create_event_types

    let(:user) { create(:admin) }
    let(:time) { Time.parse('2021-08-15 10:00:00') }
    let(:source_snapshot) { create(:source_snapshot) }
    let!(:work) { create(:work) }
    let!(:worker) { create(:worker, work: work) }
    let!(:workflow) { create(:workflow, work: work) }
    let!(:sd_request) { create(:sd_request, integration_id: 11, source_snapshot: source_snapshot, works: [work]) }
    let(:new_user) { create(:manager) }
    let(:form) { SdRequests::CreateForm.new(sd_request) }
    subject { described_class.new(form, user, 'new') }
    before do
      create(:employee)
      allow(Time.zone).to receive(:now).and_return(time)
      form.current_user = user
      form.history_store = Histories::Storage.new(user)
      form.validate({
        works: [{
          workflows: [{ message: 'test-message' }],
          workers: [{ user_id: new_user.id }]
        }]
      })
    end

    context 'when it is new form' do
      before { allow(form.model).to receive(:id).and_return(nil) }

      it { expect(subject.case_id).to eq form.integration_id }
      it { expect(subject.user_id).to eq user.tn }
      it { expect(subject.user_tn).to eq source_snapshot.tn }
      it { expect(subject.phone).to eq source_snapshot.user_attrs[:phone] }
      it { expect(subject.host_id).to eq source_snapshot.invent_num }
      it { expect(subject.barcode).to eq source_snapshot.barcode }
      it { expect(subject.desc).to eq form.description }
      it { expect(subject.rem_date).to eq form.finished_at_plan }
      it { expect(subject.rem_hour).to eq form.finished_at_plan.hour }
      it { expect(subject.rem_min).to eq form.finished_at_plan.min }
      it { expect(subject.severity).to eq form.priority }
      it { expect(subject.analysis).to eq 'test-message' }
      it { expect(subject.users.sort).to eq [worker.user.tn, new_user.tn, form.current_user.tn].sort }
    end


    context 'when it is updating form' do
      let(:form) { SdRequests::UpdateForm.new(sd_request) }
      subject { described_class.new(form, user, 'update') }

      it { expect(subject.desc).to be_nil }
      it { expect(subject.user_id).to eq user.tn }
      it { expect(subject.user_tn).to eq source_snapshot.tn }
      it { expect(subject.phone).to eq source_snapshot.user_attrs[:phone] }
      it { expect(subject.host_id).to eq source_snapshot.invent_num }
      it { expect(subject.barcode).to eq source_snapshot.barcode }
      it { expect(subject.rem_date).to eq form.finished_at_plan }
      it { expect(subject.rem_hour).to eq form.finished_at_plan.hour }
      it { expect(subject.rem_min).to eq form.finished_at_plan.min }
    end
  end
end
