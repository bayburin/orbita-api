require 'rails_helper'

module Events
  RSpec.describe Switch do
    let!(:event_type) { create(:event_type, :workflow) }
    let(:event) { EventBuilder.build(event_type: 'workflow') }
    let(:command_dbl) { double(:command, call: true) }
    before { subject.register(event.event_type.name, command_dbl) }

    describe '#register' do
      it { expect(subject.event_map[event.event_type.name]).to eq command_dbl }
    end

    describe '#call' do
      it 'call specified command' do
        expect(command_dbl).to receive(:call)

        subject.call(event)
      end

      context 'when command not found' do
        let(:event_type_dbl) { double(:event_type, name: 'unknown') }
        before { allow(event).to receive(:event_type).and_return(event_type_dbl) }

        it 'raise error' do
          expect { subject.call(event) }.to raise_error(RuntimeError, 'Неизвестное событие')
        end
      end
    end
  end
end
