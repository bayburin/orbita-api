require 'rails_helper'

module SdRequests
  RSpec.describe ValidateUpdateForm do
    let!(:sd_request) { create(:sd_request) }
    let(:error_dbl) { double(:error, messages: []) }
    let(:params) { { foo: :bar } }
    let(:form_dbl) { instance_double('UpdateForm', validate: true, errors: error_dbl) }
    subject(:context) { described_class.call(sd_request: sd_request, params: params) }
    before { allow(UpdateForm).to receive(:new).and_return(form_dbl) }

    describe '.call' do
      it { expect(context).to be_a_success }

      it 'create instance of UpdateForm' do
        expect(UpdateForm).to receive(:new).with(sd_request)

        context
      end

      it 'call validate form' do
        expect(form_dbl).to receive(:validate).with(params)

        context
      end

      context 'when validation failed' do
        before { allow(form_dbl).to receive(:validate).and_return(false) }

        it { expect(context).to be_a_failure }
      end
    end
  end
end
