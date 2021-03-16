require 'rails_helper'

module SdRequests
  RSpec.describe SdRequestForm, type: :model do
    describe 'creating model' do
      let(:user) { create(:admin) }
      let(:model) { SdRequest.new }
      let!(:time) { Time.zone.now }
      subject do
        allow(Claim).to receive(:default_finished_at_plan).and_return(time)
        described_class.new(model)
      end
      let(:params) { { sd_request: attributes_for(:sd_request) } }
      before { subject.current_user = user }


      it { is_expected.to validate_presence_of(:description) }
      it { is_expected.to validate_presence_of(:attrs) }

      describe 'default values' do
        it { expect(subject.service_name).to eq(Claim.default_service_name) }
        it { expect(subject.status).to eq(Claim.default_status) }
        it { expect(subject.priority).to eq(Claim.default_priority) }
        it { expect(subject.finished_at_plan).to eq(time) }
      end

      describe '#populate_source_snapshot!' do
        let(:ss_params) { { id_tn: 123, invent_num: 123 } }
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
          expect_any_instance_of(SourceSnapshotBuilder).to receive(:set_host_credentials).with(user, ss_params[:invent_num])

          subject.validate(params)
        end
      end

      describe '#validate' do
        let!(:user) { create(:admin) }
        let(:user_params) { [user.as_json.symbolize_keys] }
        before { subject.validate(params.merge!(users: user_params)) }

        it 'add a new work' do
          expect { subject.save }.to change { Work.count }.by(1)
        end

        it 'add users to new work' do
          subject.save

          expect(subject.model.works.last.workers.last.user).to eq(user)
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