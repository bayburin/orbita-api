require 'rails_helper'

module SdRequests
  RSpec.describe CreateForm, type: :model do
    create_event_types

    let!(:current_user) { create(:employee) }
    let(:model) { SdRequest.new }
    let!(:time) { Time.zone.now }
    let(:source_snapshot) { build(:source_snapshot) }
    let(:ss_params) { { id_tn: source_snapshot.id_tn, invent_num: source_snapshot.invent_num } }
    let(:history_store_dbl) { instance_double('Histories::Storage', add: true, add_to_combine: true) }
    let!(:params) { { sd_request: attributes_for(:sd_request, source_snapshot: ss_params) } }
    subject do
      allow(Claim).to receive(:default_finished_at_plan).and_return(time)
      described_class.new(model).tap do |form|
        form.current_user = current_user
        form.history_store = history_store_dbl
      end
    end

    it { expect(described_class).to be < SdRequestForm }

    describe 'validations' do
      let(:works) { [{ group_id: 1 }, { group_id: 1 }] }
      before { subject.validate(works: works) }

      it { expect(subject.errors.messages).to include(:description) }
      it { expect(subject.errors.messages[:description]).to include('не может быть пустым') }
      it { expect(subject.errors.messages).to include(:source_snapshot) }
      it { expect(subject.errors.messages[:source_snapshot]).to include('не может быть пустым') }
    end

    describe 'default values' do
      it { expect(subject.service_name).to eq(SdRequest.default_service_name) }
      it { expect(subject.ticket_name).to eq(SdRequest.default_ticket_name) }
      it { expect(subject.status).to eq(Claim.default_status) }
      it { expect(subject.priority).to eq(Claim.default_priority) }
      it { expect(subject.finished_at_plan).to eq(time) }
    end

    describe '#populate_source_snapshot!' do
      let(:params) { attributes_for(:sd_request, finished_at_plan: Date.today.to_s, source_snapshot: ss_params) }
      let(:ss_yield_dbl) { double(:source_snapshot_yield_dbl) }
      before do
        allow(SourceSnapshotBuilder).to receive(:build).and_yield(ss_yield_dbl).and_return(source_snapshot)
        allow(ss_yield_dbl).to receive(:user_credentials=)
        allow(ss_yield_dbl).to receive(:host_credentials=)
      end

      it 'call SourceSnapshotBuilder' do
        expect(SourceSnapshotBuilder).to receive(:build)

        subject.validate(params)
      end

      it 'set user_credentials' do
        expect(ss_yield_dbl).to receive(:user_credentials=).with(ss_params[:id_tn])

        subject.validate(params)
      end

      it 'does not set user_credentials if id_tn is empty' do
        ss_params[:id_tn] = nil
        expect(ss_yield_dbl).not_to receive(:user_credentials=)

        subject.validate(params)
      end

      it 'set host_credentials' do
        expect(ss_yield_dbl).to receive(:host_credentials=).with(ss_params[:invent_num])

        subject.validate(params)
      end

      it 'does not set host_credentials if invent_num is empty' do
        ss_params[:invent_num] = nil
        expect(ss_yield_dbl).not_to receive(:host_credentials=)

        subject.validate(params)
      end
    end

    describe '#processing_history' do
      let(:history_dbl) { instance_double(History) }
      before { allow_any_instance_of(Histories::OpenType).to receive(:build).and_return(history_dbl) }

      it 'add created history to history_store' do
        expect(history_store_dbl).to receive(:add).with(history_dbl)

        subject.validate(params)
      end
    end
  end
end
