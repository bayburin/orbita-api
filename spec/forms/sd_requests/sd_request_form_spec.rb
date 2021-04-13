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

    describe '#popualte_works!' do
      let(:manager) { create(:manager) }
      let(:params) do
        attributes_for(:sd_request).merge(
          finished_at_plan: '28 September',
          works: [{ group_id: manager.group_id, workers: [{ user_id: manager.id }] }]
        )
      end
      before { subject.validate(params) }

      it 'set current_user to each WorkForm object' do
        expect(subject.works.first.current_user).to eq current_user
      end

      it 'set history_store to each WorkForm object' do
        expect(subject.works.first.history_store).to eq history_store_dbl
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
