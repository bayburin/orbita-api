require 'rails_helper'

module Histories
  RSpec.describe CreatePostpone do
    let(:event_type) { create(:event_type, :postpone) }
    let(:user) { create(:admin) }
    let(:claim) { create(:claim) }
    let(:work) { create(:work, claim: claim) }
    let(:old_datetime) { '2020-08-20 10:00:15' }
    let(:new_datetime) { '2020-08-22 12:00:00' }
    let(:payload) { { old_datetime: old_datetime, new_datetime: new_datetime }.as_json }
    let(:event_dbl) { double(:event, event_type: event_type, user: user, claim: claim, work: work, payload: payload) }
    subject(:context) { described_class.call(event: event_dbl) }

    describe '.call' do
      it { expect(context).to be_a_success }
      it { expect { context }.to change { History.count } }
      it { expect(context.history.action).to eq event_type.template.gsub(/{old_datetime}/, old_datetime).gsub(/{new_datetime}/, new_datetime) }

      context 'when history was not created' do
        let(:errors_dbl) { double(:errors, full_messages: ['error message']) }
        before do
          allow_any_instance_of(History).to receive(:save).and_return(false)
          allow_any_instance_of(History).to receive(:errors).and_return(errors_dbl)
        end

        it { expect(context).to be_a_failure }
        it { expect { context }.not_to change { History.count } }
        it { expect(context.error).to eq errors_dbl.full_messages }
      end
    end
  end
end
