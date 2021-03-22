require 'rails_helper'

module Events
  RSpec.describe Create do
    subject { described_class.call(user: user, params: params) }

    describe '.call' do
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
        expect(sw_dbl).to receive(:call).with(EventBuilder.build(params))

        subject
      end

      it { expect(subject).to eq sw_dbl.call }
    end
  end
end
