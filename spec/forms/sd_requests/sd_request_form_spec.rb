require 'rails_helper'

module SdRequests
  RSpec.describe SdRequestForm, type: :model do
    create_event_types

    let(:user) { create(:admin) }
    let!(:sd_request) { create(:sd_request) }
    let!(:time) { Time.zone.now }
    let(:history_store_dbl) { instance_double('Histories::Storage', add: true, add_to_combine: true) }
    subject do
      allow(Claim).to receive(:default_finished_at_plan).and_return(time)
      described_class.new(sd_request).tap do |form|
        form.history_store = history_store_dbl
        form.current_user = user
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
        expect(subject.works.first.current_user).to eq user
      end

      it 'set history_store to each WorkForm object' do
        expect(subject.works.first.history_store).to eq history_store_dbl
      end
    end

    describe '#populate_comments!' do
      let!(:comment) { create(:comment, message: old_comment, claim: sd_request) }
      let(:old_comment) { 'old message' }
      let(:new_comment) { 'new message' }
      let(:history_dbl) { double(:history) }
      let(:comment_type_dbl) { instance_double('Histories::CommentType', build: history_dbl) }
      let(:params) do
        attributes_for(:sd_request).merge(
          finished_at_plan: '28 September',
          comments: [
            { id: comment.id, message: new_comment },
            { message: new_comment }
          ]
        )
      end
      before { allow(Histories::CommentType).to receive(:new).with(comment: new_comment).and_return(comment_type_dbl) }

      it 'add history with new comment' do
        expect(history_store_dbl).to receive(:add).with(history_dbl)

        subject.validate(params)
      end

      it 'does not update comment which has id' do
        subject.validate(params)
        subject.save

        expect(comment.reload.message).to eq old_comment
      end

      it 'does not add history with comment which has id' do
        expect(history_store_dbl).to receive(:add).exactly(1).times

        subject.validate(params)
      end
    end
  end
end
