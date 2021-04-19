require 'rails_helper'

RSpec.describe SdRequestBuilder do
  include_examples 'base builder', SdRequest

  describe 'instance methods' do
    let(:attr) { attributes_for(:sd_request, attrs: { foo: :bar }) }
    subject { described_class.new }

    it { expect(subject.respond_to?(:ticket=)).to be_truthy }
    it { expect(subject.respond_to?(:application_id=)).to be_truthy }

    describe '#add_works' do
      let(:work) { build(:work) }

      it 'add work to sd_request' do
        subject.add_work(work)

        expect(subject.model.works.length).to eq 1
      end
    end

    describe '#build_works_by_responsible_users' do
      let(:manager) { create(:manager) }
      let(:admin) { create(:admin) }
      let(:users) { [ { tn: manager.tn }, { tn: admin.tn }, { tn: 123 } ] }
      before do
        subject.build_works_by_responsible_users(users)
        subject.model.save
      end

      it { expect(subject.model.works.length).to eq 2 }
      it { expect(subject.model.works.first.workers.length).to eq 1 }
      it { expect(subject.model.works.last.workers.length).to eq 1 }
      it { expect(subject.model.works.find_by(group_id: manager.group_id).users.first).to eq manager }
      it { expect(subject.model.works.find_by(group_id: admin.group_id).users.first).to eq admin }
    end
  end
end
