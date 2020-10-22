require 'rails_helper'

module Claims
  RSpec.describe Create do
    let(:created_claim) { create(:claim) }
    let(:claim_params) { { } }
    let(:create_form_dbl) { double(:create_form, validate: true, save: true, model: created_claim) }
    subject(:context) { described_class.call(params: claim_params) }
    before { allow(ClaimForm).to receive(:new).and_return(create_form_dbl) }

    describe '.call' do
      it { expect(context).to be_a_success }
      it { expect(context.claim).to eq created_claim }

      it 'create instance of ClaimForm' do
        expect(ClaimForm).to receive(:new).with(an_instance_of(Claim))

        context
      end

      context 'when context.claim exist' do
        let(:claim) { Claim.new(attrs: { foo: :bar }) }
        subject(:context) { described_class.call(params: claim_params, claim: claim) }

        it 'create instance of ClaimForm with received instance of Claim' do
          expect(ClaimForm).to receive(:new).with(claim)

          context
        end
      end

      context 'when form is not saved' do
        let(:create_form_dbl) { double(:create_form, validate: false, save: false, errors: { message: 'test' }) }

        it { expect(context).to be_a_failure }
        it { expect(context.errors).to be_present }
      end
    end
  end
end
