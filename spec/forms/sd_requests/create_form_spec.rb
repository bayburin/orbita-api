require 'rails_helper'

module SdRequests
  RSpec.describe CreateForm, type: :model do
    let!(:current_user) { create(:employee) }
    let(:model) { SdRequest.new }
    let!(:time) { Time.zone.now }
    let(:ss_params) { { id_tn: 123, invent_num: 123 } }
    let(:history_yield_dbl) { double(:history) }
    let(:history) { instance_double('History') }
    let(:history_store_dbl) { instance_double('Histories::Storage') }
    let!(:params) { { sd_request: attributes_for(:sd_request, source_snapshot: ss_params) } }
    subject do
      allow(Claim).to receive(:default_finished_at_plan).and_return(time)
      described_class.new(model)
    end
    before do
      subject.current_user = current_user
      subject.history_store = history_store_dbl
      allow(HistoryBuilder).to receive(:build).and_yield(history_yield_dbl).and_return(history)
      allow(history_yield_dbl).to receive(:set_event_type)
      allow(history_store_dbl).to receive(:add)
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
      before do
        allow_any_instance_of(SourceSnapshotBuilder).to receive(:user_credentials=)
        allow_any_instance_of(SourceSnapshotBuilder).to receive(:host_credentials=)
      end

      it 'call SourceSnapshotBuilder' do
        expect(SourceSnapshotBuilder).to receive(:build).and_call_original

        subject.validate(params)
      end

      it 'set user_credentials' do
        expect_any_instance_of(SourceSnapshotBuilder).to receive(:user_credentials=).with(ss_params[:id_tn])

        subject.validate(params)
      end

      it 'does not set user_credentials if id_tn is empty' do
        ss_params[:id_tn] = nil
        expect_any_instance_of(SourceSnapshotBuilder).not_to receive(:user_credentials=)

        subject.validate(params)
      end

      it 'set host_credentials' do
        expect_any_instance_of(SourceSnapshotBuilder).to receive(:host_credentials=).with(ss_params[:invent_num])

        subject.validate(params)
      end
    end

    describe '#validate' do
      let!(:default_worker) { create(:admin, :default_worker) }
      let(:user) { create(:admin, group: create(:group)) }
      let(:work_params) { [{ group_id: user.group_id, workers: [{ user_id: user.id }] }] }

      context 'when form valid' do
        before { subject.validate(params.merge!(works: work_params)) }

        it { expect { subject.save }.to change { Work.count }.by(2) }

        it 'add users to new work' do
          subject.save

          expect(subject.model.works.first.workers.last.user).to eq(user)
        end

        it 'add current_user to user list' do
          subject.save

          expect(subject.model.works.any? { |work| work.workers.any? { |u| u.user_id == current_user.id } }).to be_truthy
        end

        context 'and when users array is not include uivt users' do
          let(:work_params) { [] }

          it { expect { subject.save }.to change { Work.count }.by(2) }

          it 'add users with "is_default_worker" flag' do
            subject.save

            expect(subject.model.users).to include(default_worker)
          end
        end

        context 'and when add multiple users with the same work' do
          let(:new_user) { create(:admin, group: user.group) }
          let(:work_params) { [{ group_id: user.group_id, workers: [{ user_id: user.id }, { user_id: new_user.id }] }] }

          it { expect { subject.save }.to change { Work.count }.by(2) }

          it 'return created groups' do
            subject.save

            expect(subject.model.works.as_json.count).to eq 2
          end
        end
      end
    end

    describe '#sync' do
      it 'set :created event_type' do
        expect(history_yield_dbl).to receive(:set_event_type).with(:created)

        subject.sync
      end

      it 'add created history to history_store' do
        expect(history_store_dbl).to receive(:add).with(history)

        subject.sync
      end
    end
  end
end
