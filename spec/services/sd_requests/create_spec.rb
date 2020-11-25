require 'rails_helper'

module SdRequests
  RSpec.describe Create do
    let(:created_sd_request) { create(:sd_request) }
    let(:sd_request_params) { { } }
    let(:create_form_dbl) { double(:create_form, validate: true, save: true, model: created_sd_request) }
    subject(:context) { described_class.call(params: sd_request_params) }
    before { allow(SdRequestForm).to receive(:new).and_return(create_form_dbl) }

    describe '.call' do
      it { expect(context).to be_a_success }
      it { expect(context.sd_request).to eq created_sd_request }

      it 'create instance of SdRequestForm' do
        expect(SdRequestForm).to receive(:new).with(an_instance_of(SdRequest))

        context
      end

      context 'when context.sd_request exist' do
        let(:sd_request) { SdRequest.new(attrs: { foo: :bar }) }
        subject(:context) { described_class.call(params: sd_request_params, sd_request: sd_request) }

        it 'create instance of SdRequestForm with received instance of SdRequest' do
          expect(SdRequestForm).to receive(:new).with(sd_request)

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
