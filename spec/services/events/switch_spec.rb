require 'rails_helper'

module Events
  RSpec.describe Switch do
    let(:event) { Event.new(type: 'test name') }
    let(:command_dbl) { double(:command, call: true) }
    before { subject.register(event.type, command_dbl) }

    describe '#register' do
      it { expect(subject.event_map[event.type]).to eq command_dbl }
    end

    describe '#call' do
      it 'call specified command' do
        expect(command_dbl).to receive(:call)

        subject.call(event)
      end

      context 'when command not found' do
        before { allow(event).to receive(:type).and_return('unknown') }

        it 'raise error' do
          expect { subject.call(event) }.to raise_error(RuntimeError, 'Неизвестное событие')
        end
      end
    end
  end
end
