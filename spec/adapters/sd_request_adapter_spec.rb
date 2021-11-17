require 'rails_helper'

RSpec.describe SdRequestAdapter do
  let!(:current_user) { create(:manager) }
  let!(:kase) { build(:astraea_kase) }
  subject { described_class.new(kase, current_user) }

  it { expect(subject.description).to eq kase.desc }
  it { expect(subject.priority).to eq kase.severity }

  describe '#finished_at_plan' do
    it { expect(subject.finished_at_plan).to eq Time.zone.at(kase.time).to_s }

    context 'when time is nil' do
      let!(:sd_request) { create(:sd_request) }
      let!(:kase) { build(:astraea_kase, time: nil) }
      subject { described_class.new(kase, current_user, sd_request: sd_request) }

      it { expect(subject.finished_at_plan).to eq sd_request.finished_at_plan.to_s }
    end
  end

  describe '#status' do
    context 'when status_id is equal 1' do
      let!(:kase) { build(:astraea_kase, status_id: 1) }

      it { expect(subject.status).to eq :opened }
    end

    context 'when status_id is equal 2' do
      let!(:kase) { build(:astraea_kase, status_id: 2) }

      it { expect(subject.status).to eq :at_work }
    end

    context 'when status_id is equal 3' do
      let!(:kase) { build(:astraea_kase, status_id: 3) }

      it { expect(subject.status).to eq :done }
    end

    context 'when status_id is equal 5' do
      let!(:kase) { build(:astraea_kase, status_id: 5) }

      it { expect(subject.status).to eq :canceled }
    end
  end

  describe '#source_snapshot' do
    it { expect(subject.source_snapshot).to be_instance_of(SourceSnapshot) }
    it { expect(subject.source_snapshot.barcode).to eq kase.item_id }
    it { expect(subject.source_snapshot.invent_num).to eq kase.host_id }
    it { expect(subject.source_snapshot.id_tn).to eq kase.id_tn }
    it { expect(subject.source_snapshot.user_attrs).to eq({ phone: kase.phone }.as_json) }

    context 'when phone is empty' do
      before { allow(kase).to receive(:phone).and_return(nil) }

      it { expect(subject.source_snapshot.user_attrs).to be_nil }
    end
  end

  describe '#comments' do
    it { expect(subject.comments.first).to be_instance_of(Comment) }
    it { expect(subject.comments.first.message).to eq kase.messages.select { |m| m[:type] == 'comment' }.first[:info] }
  end

  context 'with ticket_id' do
    let!(:kase) { build(:astraea_kase, ticket_id: 11) }
    let(:ticket) { build(:sd_ticket) }
    let(:ticket_response_dbl) { double(:response, success?: true, body: ticket) }
    before { allow(ServiceDesk::ServerApi).to receive(:ticket).and_return(ticket_response_dbl) }

    it 'load ticket data' do
      expect(ServiceDesk::ServerApi).to receive(:ticket).with(kase.ticket_id)

      described_class.new(kase, current_user)
    end
    it { expect(subject.service_id).to eq ticket.service.id }
    it { expect(subject.service_name).to eq ticket.service.name }
    it { expect(subject.ticket_identity).to eq ticket.identity }
    it { expect(subject.ticket_name).to eq ticket.name }
  end

  describe '#build_works' do
    context 'when current_user exists into users array' do
      let(:users) { [build(:manager).tn, build(:manager).tn, current_user.tn] }
      let!(:kase) { build(:astraea_kase, users: users) }

      it { expect(subject.works.length).to eq kase.users.length }
      it { expect(subject.works.find { |w| w.group_id == current_user.group_id }.workflows.length).to eq 1 }
      it { expect(subject.works.find { |w| w.group_id == current_user.group_id }.workflows.first.message).to eq 'Анализ: fake analysis; Меры: fake measure' }
    end

    context 'when current_user is not exist into users array' do
      it { expect(subject.works.length).to eq kase.users.length + 1 }
      it { expect(subject.works.last.workflows.length).to eq 1 }
      it { expect(subject.works.last.workflows.first.message).to eq 'Анализ: fake analysis; Меры: fake measure' }

      context 'and when message has only comment type' do
        let(:messages) { [{ type: 'comment', info: 'fake comment' }] }
        let!(:kase) { build(:astraea_kase, messages: messages) }

        it { expect(subject.works.last.workflows.length).to eq 0 }
      end
    end

    context 'when @sd_request exist' do
      let!(:remove_user) { create(:manager) }
      let!(:new_user) { create(:manager) }
      let!(:sd_request) { create(:sd_request) }
      let(:kase) { build(:astraea_kase, users: [create(:manager).tn, create(:manager).tn, new_user.tn]) }
      let!(:work1) { create(:work, claim: sd_request, group: remove_user.group, workers: [build(:worker, user: remove_user)]) }
      let!(:work2) { create(:work, claim: sd_request, group: new_user.group, workers: []) }
      subject { described_class.new(kase, current_user, sd_request: sd_request) }

      it { expect(subject.works.find { |w| w.id == work1.id }.workers.first._destroy).to eq true }
      it { expect(subject.works.length).to eq sd_request.works.length + kase.users.length }
      it { expect(subject.works.find { |w| w.id == work2.id }.workers.find { |w| w.user_id == new_user.id }).to be_truthy  }
    end
  end
end
