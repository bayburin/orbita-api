require 'rails_helper'

module SdRequests
  RSpec.describe CreateForm, type: :model do
    describe 'creating model' do
      let!(:current_user) { create(:employee) }
      let(:model) { SdRequest.new }
      let!(:time) { Time.zone.now }
      let(:ss_params) { { id_tn: 123, invent_num: 123 } }
      let!(:params) { { sd_request: attributes_for(:sd_request, source_snapshot: ss_params) } }
      subject do
        allow(Claim).to receive(:default_finished_at_plan).and_return(time)
        described_class.new(model)
      end
      before { subject.current_user = current_user }

      it { is_expected.to validate_presence_of(:description) }
      it { is_expected.to validate_presence_of(:source_snapshot) }

      describe 'default values' do
        it { expect(subject.service_name).to eq(SdRequest.default_service_name) }
        it { expect(subject.ticket_name).to eq(SdRequest.default_ticket_name) }
        it { expect(subject.status).to eq(Claim.default_status) }
        it { expect(subject.priority).to eq(Claim.default_priority) }
        it { expect(subject.finished_at_plan).to eq(time) }
      end

      describe '#populate_source_snapshot!' do
        let(:params) { attributes_for(:sd_request, source_snapshot: ss_params) }
        let(:source_snapshot_dbl) { double(:source_snapshot) }
        before do
          allow_any_instance_of(SourceSnapshotBuilder).to receive(:user_credentials=)
          allow_any_instance_of(SourceSnapshotBuilder).to receive(:set_host_credentials)
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
          expect_any_instance_of(SourceSnapshotBuilder).to receive(:set_host_credentials).with(ss_params[:invent_num])

          subject.validate(params)
        end
      end

      describe '#validate' do
        let!(:default_worker) { create(:admin, :default_worker) }
        let(:user) { create(:admin, group: create(:group)) }
        let(:user_params) { [user.as_json.symbolize_keys] }

        context 'when form valid' do
          before { subject.validate(params.merge!(users: user_params)) }

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
            let(:user_params) { [] }

            it { expect { subject.save }.to change { Work.count }.by(2) }

            it 'add users with "is_default_worker" flag' do
              subject.save

              expect(subject.model.users).to include(default_worker)
            end
          end

          context 'and when add multiple users with the same work' do
            let(:new_user) { create(:admin, group: user.group) }
            let(:user_params) { [user.as_json.symbolize_keys, new_user.as_json.symbolize_keys] }

            it { expect { subject.save }.to change { Work.count }.by(2) }

            it 'return created groups' do
              subject.save

              expect(subject.model.works.as_json.count).to eq 2
            end
          end
        end

        context 'when SourceSnapshotForm is not valid' do
          it { expect(subject.validate(params.merge!({ source_snapshot: {} }))).to be_falsey }

          it 'add source_snapshot errors' do
            subject.validate(params.merge!({ source_snapshot: {} }))

            expect(subject.errors.as_json).to include('source_snapshot')
          end
        end
      end
    end

    # describe 'updating model' do
    #   let!(:user) { create(:admin) }
    #   let!(:sd_request) { create(:sd_request) }
    #   let(:params) { { sd_request: attributes_for(:sd_request).merge(id: sd_request.id) } }
    #   subject { described_class.new(sd_request) }
    #   before { subject.current_user = user }

    #   describe '#validate' do
    #     let(:user_params) { [user.as_json.symbolize_keys] }
    #     let!(:work) { create(:work, claim: sd_request, group: user.group) }
    #     before do
    #       sd_request.works << work
    #       subject.validate(params.merge!(users: user_params))
    #     end

    #     it 'should not add a new work' do
    #       expect { subject.save }.not_to change { Work.count }
    #     end

    #     it 'add users to existing work' do
    #       subject.save

    #       expect(subject.model.works.last.workers.last.user).to eq(user)
    #     end

    #     context 'when user already exist at work' do
    #       before { sd_request.works.last.users << user }

    #       # ! TODO: Тест не проходит
    #       it 'does not add user to work' do
    #         expect { subject.save }.not_to change { Worker.count }
    #       end
    #     end
    #   end
    # end
  end
end
