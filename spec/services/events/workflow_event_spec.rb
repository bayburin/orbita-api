require 'rails_helper'

module Events
  RSpec.describe WorkflowEvent do
    let(:user) { create(:admin) }
    let(:claim) { create(:claim) }
    let(:payload) { { message: 'Test payload message' }.as_json }
    let(:event) { double(:event, claim_id: claim.id, id_tn: user.id_tn, payload: payload) }
    subject(:context) { described_class.call(event: event) }

    describe '.call' do
      it { expect(context).to be_a_success }
      it { expect { context }.to change { Work.count }.by(1) }
      it { expect(context.work.group_id).to eq user.group_id }
      it { expect { context }.to change { Workflow.count } }
      it { expect(context.workflow.message).to eq payload['message'] }

      context 'when claim not found' do
        before { claim.id = 'unknown' }

        it { expect { context }.to raise_error(ActiveRecord::RecordNotFound) }
      end

      context 'when user not found' do
        before { allow(User).to receive(:find_by).and_return(nil) }

        it { expect(context).to be_a_failure }
        it { expect(context.error).to eq 'Пользователь не найден' }
      end

      context 'when workflow was not created' do
        before { allow_any_instance_of(Workflow).to receive(:save).and_return(false) }

        it { expect { context }.not_to change { Work.count } }
      end

      context 'when work of user group exist' do
        let!(:work) { create(:work, claim: claim, group_id: user.group_id) }

        it { expect { context }.not_to change { Work.count } }

        it 'include user to workers array if it is not included yet' do
          context

          expect(work.users).to include(user)
        end

        context 'and when workflow was not created' do
          before { allow_any_instance_of(Workflow).to receive(:save).and_return(false) }

          it 'does not include user to workers array' do
            context

            expect(work.users).not_to include(user)
          end
        end
      end
    end
  end
end
