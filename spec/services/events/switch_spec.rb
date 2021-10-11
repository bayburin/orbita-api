require 'rails_helper'

module Events
  RSpec.describe Switch do
    let!(:event_type) { create(:event_type, :workflow) }
    let(:event_dbl) { double(:event, event_type: event_type) }
    let(:command_dbl) { double(:command, call: true) }
    before do
      subject.register(event_dbl.event_type.name, command_dbl)
      allow(EventBuilder).to receive(:build).and_return(event_dbl)
    end

    describe '#register' do
      it { expect(subject.event_map[event_dbl.event_type.name]).to eq command_dbl }
    end

    describe '#call' do
      it 'call specified command' do
        expect(command_dbl).to receive(:call)

        subject.call(event_dbl)
      end

      context 'when command not found' do
        let(:event_type_dbl) { double(:event_type, name: 'unknown') }
        before { allow(event_dbl).to receive(:event_type).and_return(event_type_dbl) }

        it 'raise error' do
          expect { subject.call(event_dbl) }.to raise_error(RuntimeError, 'Неизвестное событие')
        end
      end
    end
  end
end
