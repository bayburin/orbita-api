require 'rails_helper'

module Events
  RSpec.describe Handler do
    subject { described_class }

    describe '.call' do
      let(:sw_dbl) { double(:sw, register: true, call: true) }
      let(:params) { { foo: :bar } }
      before do
        allow(Event).to receive(:new).with(**params)
        allow(Switch).to receive(:new).and_return(sw_dbl)
      end

      it 'register all event types' do
        expect(sw_dbl).to receive(:register).with('action', ActionEvent)
        expect(sw_dbl).to receive(:register).with('close', CloseEvent)

        subject.call(params: params)
      end

      it 'call "call" method of Switch instance with Event instance argument' do
        expect(sw_dbl).to receive(:call).with(Event.new(params))

        subject.call(params: params)
      end

      it { expect(subject.call(params: params)).to eq sw_dbl.call }
    end
  end
end