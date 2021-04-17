require 'rails_helper'

RSpec.describe AstraeaAdapter do
  let!(:kase) { build(:astraea_kase) }
  subject { described_class.new(kase) }

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

      described_class.new(kase)
    end
    it { expect(subject.service_id).to eq ticket.service.id }
    it { expect(subject.service_name).to eq ticket.service.name }
    it { expect(subject.ticket_identity).to eq ticket.identity }
    it { expect(subject.ticket_name).to eq ticket.name }
  end
end
