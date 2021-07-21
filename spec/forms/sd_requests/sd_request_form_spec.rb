require 'rails_helper'

module SdRequests
  RSpec.describe SdRequestForm, type: :model do
    create_event_types

    let!(:current_user) { create(:employee) }
    let!(:sd_request) { create(:sd_request) }
    let!(:time) { Time.zone.now }
    let(:history_store_dbl) { instance_double('Histories::Storage', add: true, add_to_combine: true) }
    let!(:params) { { sd_request: attributes_for(:sd_request) } }
    subject do
      allow(Claim).to receive(:default_finished_at_plan).and_return(time)
      described_class.new(sd_request).tap do |form|
        form.history_store = history_store_dbl
        form.current_user = current_user
      end
    end

    describe 'validations' do
      describe 'works' do
        let(:works) { [{ group_id: 1 }, { group_id: 1 }] }
        before { subject.validate(works: works) }

        it { expect(subject.errors.messages).to include(:works) }
        it { expect(subject.errors.messages[:works]).to include('имеются дублирующиеся группы') }
      end
    end

    describe '#priority' do
      it 'return default priority if it is nil' do
        subject.priority = nil

        expect(subject.priority).to eq Claim.default_priority
      end

      context 'when priority is not null' do
        let(:priority) { 'low' }
        before { subject.priority = priority }

        it { expect(subject.priority).to eq priority }
      end
    end

    describe '#finished_at_plan' do
      it 'return default finished_at_plan if it is nil' do
        subject.finished_at_plan = nil

        expect(subject.finished_at_plan).to eq Claim.default_finished_at_plan
      end

      context 'when finished_at_plan is not null' do
        let(:finished_at_plan) { Time.zone.now - 10.days }
        before { subject.finished_at_plan = finished_at_plan }

        it { expect(subject.finished_at_plan).to eq finished_at_plan }
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
      context 'when some attributes is nil' do
        let!(:time) { Time.parse('2020-08-20 10:00:15') }
        before do
          allow(Claim).to receive(:default_finished_at_plan).and_return(time)
          subject.priority = nil
          subject.finished_at_plan = nil
          subject.sync
        end

        it { expect(subject.model.priority).to eq Claim.default_priority.to_s }
        it { expect(subject.model.finished_at_plan).to eq Claim.default_finished_at_plan }
      end
    end

    describe '#popualte_works!' do
      let(:manager) { create(:manager) }
      let(:params) do
        attributes_for(:sd_request).merge(
          finished_at_plan: '28 September',
          works: [{ group_id: manager.group_id, workers: [{ user_id: manager.id }] }]
        )
      end
      before { subject.validate(params) }

      it { expect(subject.works.first.current_user).to eq current_user }
      it { expect(subject.works.first.history_store).to eq history_store_dbl }
      it { expect(subject.works.first.employee_user).to eq User.employee_user }
    end

    describe '#popualte_attachments!' do
      let(:new_file) { Rack::Test::UploadedFile.new(File.open(Rails.root.join('spec', 'uploads', 'test_file.txt'))) }
      let(:new_attachment) { { attachment: nil } }
      let(:del_attachment) { create(:attachment, claim_id: sd_request.id) }
      let(:params) do
        attrs = attributes_for(:sd_request).merge(
          attachments: [
            new_attachment.as_json,
            del_attachment.as_json.merge(_destroy: 'true')
          ]
        )
        attrs[:attachments][0]['attachment'] = new_file
        attrs
      end

      it 'should add new attachment' do
        subject.validate(params.deep_symbolize_keys)

        expect(subject.attachments.length).to be 1
      end

      it 'should call add_to_combine method with new attachment for history_store' do
        expect(history_store_dbl).to receive(:add_to_combine).with(:add_files, new_file.original_filename)

        subject.validate(params.deep_symbolize_keys)
      end

      it 'should call add_to_combine method with destroyed attachment for history_store' do
        expect(history_store_dbl).to receive(:add_to_combine).with(:del_files, del_attachment.attachment.file.filename)

        subject.validate(params.deep_symbolize_keys)
      end
    end

    describe '#populate_comments!' do
      let!(:comment) { create(:comment, message: old_comment, claim: sd_request) }
      let(:old_comment) { 'old message' }
      let(:new_comment) { 'new message' }
      let(:params) do
        attributes_for(:sd_request).merge(
          finished_at_plan: '28 September',
          comments: [
            { id: comment.id, message: new_comment },
            { message: new_comment }
          ]
        )
      end

      it 'does not update comment which has id' do
        subject.validate(params)
        subject.save

        expect(comment.reload.message).to eq old_comment
      end
    end
  end
end
