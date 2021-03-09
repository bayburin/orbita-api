require 'rails_helper'

RSpec.describe HistoryBuilder do
  include_examples 'base builder', History

  describe '#set_event_type' do
    let!(:event_type) { create(:event_type, :created) }

    it 'set event_type' do
      subject.set_event_type :created

      expect(subject.model.event_type).to eq event_type
    end

    it { expect { subject.set_event_type :test }.to raise_error(RuntimeError) }

    it 'copy template from event_type' do
      subject.set_event_type :created

      expect(subject.model.action).to eq event_type.template
    end

    context 'if event_type template has any attributes' do
      let!(:event_type) { create(:event_type, :workflow) }
      let(:message) { 'Test message' }

      it 'copy template from event_type and replace attributes' do
        subject.set_event_type :workflow, message: message

        expect(subject.model.action).to eq event_type.template.gsub!(/{message}/, message)
      end
    end
  end
end
