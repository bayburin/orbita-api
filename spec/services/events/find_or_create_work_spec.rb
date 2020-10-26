require 'rails_helper'

module Events
  RSpec.describe FindOrCreateWork do
    let(:user) { create(:admin) }
    let(:claim) { create(:claim) }
    subject(:context) { described_class.call(claim: claim, user: user) }

    describe '.call' do
      it { expect(context).to be_a_success }
      it { expect { context }.to change { Work.count }.by(1) }
      it { expect(context.work.group_id).to eq user.group_id }

      context 'when work was not created' do
        let(:errors_dbl) { double(:errors, full_messages: ['error message']) }
        before do
          allow_any_instance_of(Work).to receive(:save).and_return(false)
          allow_any_instance_of(Work).to receive(:errors).and_return(errors_dbl)
        end

        it { expect { context }.not_to change { Work.count } }
        it { expect(context).to be_a_failure }
        it { expect(context.error).to eq errors_dbl.full_messages }
      end

      context 'when work of user group exist' do
        let!(:work) { create(:work, claim: claim, group_id: user.group_id) }

        it { expect { context }.not_to change { Work.count } }

        it 'include user to workers array if it is not included yet' do
          context

          expect(work.users).to include(user)
        end
      end
    end
  end
end
