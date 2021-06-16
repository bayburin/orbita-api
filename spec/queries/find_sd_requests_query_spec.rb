require 'rails_helper'

RSpec.describe FindSdRequestsQuery do
  describe '#call' do
    let(:params) { { filters: filters.to_json } }
    before do
      create_list(:sd_request, 3)
    end

    context 'with filter by id' do
      let(:id) { SdRequest.last.id }
      let(:filters) { { id: id } }

      it { expect(subject.call(params).length).to eq 1 }
      it { expect(subject.call(params).first.id).to eq id }
    end

    context 'with filter by created_at' do
      let(:created_at) { SdRequest.last.created_at }
      let(:filters) { { created_at: created_at } }
      before { create(:sd_request, created_at: rand(10.years).seconds.ago) }

      it { expect(subject.call(params).length).to eq 1 }
      it { expect(subject.call(params).first.created_at).to eq created_at }
    end

    context 'with filter by status' do
      let(:filters) { { status: :done } }
      before { create(:sd_request, status: :done) }

      it { expect(subject.call(params).length).to eq 1 }
      it { expect(subject.call(params).first.status).to eq 'done' }
    end

    context 'with filter by service_id' do
      let(:filters) { { service_id: 123 } }
      before { create(:sd_request, service_id: 123) }

      it { expect(subject.call(params).length).to eq 1 }
      it { expect(subject.call(params).first.service_id).to eq 123 }
    end

    context 'with filter by ticket_identity' do
      let(:filters) { { ticket_identity: 321 } }
      before { create(:sd_request, ticket_identity: 321) }

      it { expect(subject.call(params).length).to eq 1 }
      it { expect(subject.call(params).first.ticket_identity).to eq 321 }
    end

    context 'with filter by description' do
      let(:description) { 'fake description' }
      let(:filters) { { description: 'fake' } }
      before { create(:sd_request, description: description) }

      it { expect(subject.call(params).length).to eq 1 }
      it { expect(subject.call(params).first.description).to eq description }
    end

    context 'with filter by priority' do
      let(:filters) { { priority: :low } }
      before { create(:sd_request, priority: :low) }

      it { expect(subject.call(params).length).to eq 1 }
      it { expect(subject.call(params).first.priority).to eq 'low' }
    end

    context 'with filter by users' do
      let(:sd_request) { create(:sd_request) }
      let(:users) { create_list(:manager, 3) }
      let!(:work) { create(:work, claim: sd_request, workers: [create(:worker, user: users[0]), create(:worker, user: users[1]), create(:worker, user: users[2])]) }
      let(:another_users) { create_list(:manager, 3) }
      let(:filters) { { users: users.map(&:id) } }
      before { create(:work, claim: SdRequest.first, workers: [create(:worker, user: another_users[0]), create(:worker, user: another_users[1]), create(:worker, user: another_users[2])]) }

      it { expect(subject.call(params).length).to eq 1 }
      it { expect(subject.call(params).first.id).to eq sd_request.id }
    end
  end
end
