require 'rails_helper'

module Events
  RSpec.describe Create do
    let(:claim) { create(:claim) }
    let(:user) { create(:admin) }
    let(:sw_dbl) { double(:sw, register: true, call: true) }
    let(:event_dbl) { double('event') }
    subject { described_class.call(claim: claim, user: user, event_type: :workflow, need_update_astraea: true) }
    before do
      allow(EventBuilder).to receive(:build).and_return(event_dbl)
      allow(Switch).to receive(:new).and_return(sw_dbl)
    end

    describe '.call' do
      it 'register all event types' do
        expect(sw_dbl).to receive(:register).with('workflow', WorkflowEvent)
        expect(sw_dbl).to receive(:register).with('close', CloseEvent)
        expect(sw_dbl).to receive(:register).with('add_files', AddFilesEvent)
        expect(sw_dbl).to receive(:register).with('to_user_message', ToUserMessageEvent)
        expect(sw_dbl).to receive(:register).with('to_user_accept', ToUserAcceptEvent)
        expect(sw_dbl).to receive(:register).with('from_user_accept', FromUserAcceptEvent)
        expect(sw_dbl).to receive(:register).with('add_workers', AddWorkersEvent)
        expect(sw_dbl).to receive(:register).with('del_workers', DelWorkersEvent)

        subject
      end

      it 'call "call" method of Switch instance with Event instance argument' do
        expect(sw_dbl).to receive(:call).with(event_dbl, true)

        subject
      end

      it { expect(subject).to eq sw_dbl.call }
    end
  end
end
