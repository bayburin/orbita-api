require 'rails_helper'

module Comments
  RSpec.describe Save do
    let(:user) { create(:admin) }
    let!(:claim) { create(:claim) }
    let(:created_comment) { create(:comment, claim: claim)  }
    let(:error_dbl) { double(:error, messages: [{ foo: :bar }]) }
    let(:form_dbl) { double(:form, save: true, validate: true, model: created_comment, errors: error_dbl) }
    let(:params) { { claim_id: claim.id, message: 'fake-message' } }
    subject(:context) do
      described_class.call(
        claim: claim,
        current_user: user,
        params: params
      )
    end
    before do
      allow(MessageForm).to receive(:new).and_return(form_dbl)
    end

    describe '.call' do
      it { expect(context).to be_a_success }

      it 'create form' do
        expect(MessageForm).to receive(:new).with(instance_of(Comment)).and_return(form_dbl)

        subject
      end

      it 'validate created form' do
        expect(form_dbl).to receive(:validate).with(params.merge(sender_id: user.id))

        subject
      end

      it 'save created form' do
        expect(form_dbl).to receive(:save)

        subject
      end

      it { expect(subject.comment).to eq created_comment }
    end
  end
end
