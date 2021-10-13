require 'rails_helper'

module Events
  RSpec.describe Create do
    subject { described_class.call(claim: claim, user: user, params: params, need_update_astraea: true) }

    describe '.call' do
      let(:claim) { create(:claim) }
      let(:user) { create(:admin) }
      let(:sw_dbl) { double(:sw, register: true, call: true) }
      let(:params) { { foo: :bar } }
      before do
        allow(EventBuilder).to receive(:build).with(**params)
        allow(Switch).to receive(:new).and_return(sw_dbl)
      end

      it 'register all event types' do
        expect(sw_dbl).to receive(:register).with('workflow', WorkflowEvent)
        expect(sw_dbl).to receive(:register).with('close', CloseEvent)

        subject
      end

      it 'call "call" method of Switch instance with Event instance argument' do
        expect(sw_dbl).to receive(:call).with(EventBuilder.build(params), true)

        subject
      end

      it { expect(subject).to eq sw_dbl.call }
    end
  end
end
