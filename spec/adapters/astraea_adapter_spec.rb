require 'rails_helper'

RSpec.describe AstraeaAdapter do
  let!(:current_user) { create(:manager) }
  let!(:kase) { build(:astraea_kase) }
  subject { described_class.new(kase, current_user) }

  it { expect(subject.id).to eq kase.case_id }
  it { expect(subject.description).to eq kase.desc }
  it { expect(subject.priority).to eq kase.severity }
  it { expect(subject.finished_at_plan).to eq Time.zone.at(kase.time) }

  describe '#source_snapshot' do
    it { expect(subject.source_snapshot).to be_instance_of(SourceSnapshot) }
    it { expect(subject.source_snapshot.svt_item_id).to eq kase.item_id }
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
    before { allow(ServiceDesk::Api).to receive(:ticket).and_return(ticket_response_dbl) }

    it 'load ticket data' do
      expect(ServiceDesk::Api).to receive(:ticket).with(kase.ticket_id)

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
      # it { expect(subject.works.find { |w| w[:group_id] == current_user.group_id }[:workflows].length).to eq 1 }
      it { expect(subject.works.find { |w| w.group_id == current_user.group_id }.workflows.first.message).to eq 'Анализ: fake analysis; Меры: fake measure' }
      # it { expect(subject.works.find { |w| w[:group_id] == current_user.group_id }[:workflows].first[:message]).to eq 'Анализ: fake analysis; Меры: fake measure' }
    end

    context 'when current_user is not exist into users array' do
      it { expect(subject.works.length).to eq kase.users.length + 1 }
      it { expect(subject.works.last.workflows.length).to eq 1 }
      # it { expect(subject.works.last[:workflows].length).to eq 1 }
      it { expect(subject.works.last.workflows.first.message).to eq 'Анализ: fake analysis; Меры: fake measure' }
      # it { expect(subject.works.last[:workflows].first[:message]).to eq 'Анализ: fake analysis; Меры: fake measure' }

      context 'and when message has only comment type' do
        let(:messages) { [{ type: 'comment', info: 'fake comment' }] }
        let!(:kase) { build(:astraea_kase, messages: messages) }

        it { expect(subject.works.last.workflows.length).to eq 0 }
      end
    end
  end
end
