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
    before { allow_any_instance_of(JobInfo::CalculateClaimEndTime).to receive(:calculate).and_return('new-date') }

    it { expect(described_class).to be < SdRequestForm }

    describe 'validations' do
      let(:works) { [{ group_id: 1 }, { group_id: 1 }] }
      before { subject.validate(works: works) }

      it { expect(subject.errors.messages).to include(:description) }
      it { expect(subject.errors.messages[:description]).to include('не может быть пустым') }
      it { expect(subject.errors.messages).to include(:source_snapshot) }
      it { expect(subject.errors.messages[:source_snapshot]).to include('не может быть пустым') }
    end

    describe '#service_name' do
      it 'return default service_name if it is nil' do
        subject.service_name = nil

        expect(subject.service_name).to eq SdRequest.default_service_name
      end

      context 'when service_name is not null' do
        let(:service_name) { 'test service' }
        before { subject.service_name = service_name }

        it { expect(subject.service_name).to eq service_name }
      end
    end

    describe '#ticket_name' do
      it 'return default ticket_name if it is nil' do
        subject.ticket_name = nil

        expect(subject.ticket_name).to eq SdRequest.default_ticket_name
      end

      context 'when ticket_name is not null' do
        let(:ticket_name) { 'test ticket' }
        before { subject.ticket_name = ticket_name }

        it { expect(subject.ticket_name).to eq ticket_name }
      end
    end

    describe '#status' do
      it 'return default status if it is nil' do
        subject.status = nil

        expect(subject.status).to eq SdRequest.default_status
      end

      context 'when status is not null' do
        let(:status) { 'approved' }
        before { subject.status = status }

        it { expect(subject.status).to eq status }
      end
    end

    describe '#sync' do
      context 'when some attributes is nil' do
        before do
          subject.service_name = nil
          subject.ticket_name = nil
          subject.status = nil
          subject.sync
        end

        it { expect(subject.model.service_name).to eq SdRequest.default_service_name }
        it { expect(subject.model.ticket_name).to eq SdRequest.default_ticket_name }
        it { expect(subject.model.status).to eq SdRequest.default_status.to_s }
      end

      context 'when description has many spaces' do
        let(:description) { '   some spaces     ' }
        before do
          subject.description = description
          subject.sync
        end

        it { expect(subject.model.description).to eq description.strip }
      end
    end

    describe '#validate' do
      describe '#finished_at_plan' do
        let(:job_info_dbl) { instance_double(JobInfo::CalculateClaimEndTime, calculate: 'new-date') }
        let(:time) { Time.parse('2021-08-15 10:00:00') }
        before do
          subject.validate({ sla: 1 })
          allow(Time.zone).to receive(:now).and_return(time)
          allow(JobInfo::CalculateClaimEndTime).to receive(:new).with(subject.current_user.tn, time, subject.sla).and_return(job_info_dbl)
        end

        it 'calls JobInfo::CalculateClaimEndTime' do
          expect(job_info_dbl).to receive(:calculate)

          subject.validate({ sla: 1 })
        end

        it 'save date into "finished_at_plan" attribute' do
          subject.validate({ sla: 1 })

          expect(subject.finished_at_plan).to eq 'new-date'
        end
      end
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
