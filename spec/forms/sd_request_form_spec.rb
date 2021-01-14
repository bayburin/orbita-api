require 'rails_helper'

RSpec.describe SdRequestForm, type: :model do
  describe 'creating model' do
    subject { described_class.new(SdRequest.new) }
    let(:params) { { sd_request: attributes_for(:sd_request) } }

    it { is_expected.to validate_presence_of(:service_name) }
    it { is_expected.to validate_presence_of(:attrs) }

    describe 'default values' do
      let!(:time) { Time.parse('2020-08-20 10:00:15') }
      before do
        allow(Time.zone).to receive(:now).and_return(time)
        subject.validate({})
      end

      it { expect(subject.status).to eq(:opened) }
      it { expect(subject.priority).to eq(:default) }
      it { expect(subject.finished_at_plan).to eq(Time.zone.now + 3.days) }
    end

    describe '#populate_source_snapshot!' do
      let(:ss_params) { { id_tn: 123 } }
      let(:params) { attributes_for(:sd_request, source_snapshot: ss_params) }
      let(:source_snapshot_dbl) { double(:source_snapshot) }
      before do
        allow_any_instance_of(SourceSnapshotBuilder).to receive(:user_credentials=)
      end

      it 'call SourceSnapshotBuilder' do
        expect(SourceSnapshotBuilder).to receive(:build).and_call_original

        subject.validate(params)
      end

      it 'set user_credentials' do
        expect_any_instance_of(SourceSnapshotBuilder).to receive(:user_credentials=).with(ss_params[:id_tn])

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

  describe 'updating model' do
    let!(:sd_request) { create(:sd_request) }
    let(:params) { { sd_request: attributes_for(:sd_request).merge(id: sd_request.id) } }

    subject { described_class.new(sd_request) }

    describe '#validate' do
      let!(:user) { create(:admin) }
      let(:user_params) { [user.as_json.symbolize_keys] }
      let!(:work) { create(:work, claim: sd_request, group: user.group) }
      before { subject.validate(params.merge!(users: user_params)) }

      it 'should not add a new work' do
        expect { subject.save }.not_to change { Work.count }
      end

      it 'add users to existing work' do
        subject.save

        expect(subject.model.works.last.workers.last.user).to eq(user)
      end

      context 'when user already exist at work' do
        before { sd_request.works.last.users << user }

        it 'does not add user to work' do
          expect { subject.save }.not_to change { Worker.count }
        end
      end
    end
  end
end
