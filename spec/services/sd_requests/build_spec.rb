require 'rails_helper'

module SdRequests
  RSpec.describe Build do
    let(:sd_request) { build(:sd_request) }
    let(:history) { build(:history) }
    let(:user) { create(:admin) }
    let(:params) { { foo: :bar } }
    subject(:context) { described_class.call(params: params, current_user: user) }
    let(:form_dbl) { instance_double('SdRequestForm', validate: true, errors: {}) }
    before do
      allow(SdRequestForm).to receive(:new).and_return(form_dbl)
      allow(form_dbl).to receive(:current_user=)
      allow(HistoryBuilder).to receive(:build).and_return(history)
    end

    describe '.call' do
      it { expect(context.history_store).to be_instance_of Histories::Storage }
      it { expect(context).to be_a_success }

      it 'create instance of SdRequestForm' do
        expect(SdRequestForm).to receive(:new).with(an_instance_of(SdRequest))

        context
      end

      context 'when context.sd_request exist' do
        let(:sd_request) { SdRequest.new(attrs: { foo: :bar }) }
        subject(:context) { described_class.call(sd_request: sd_request) }

        it 'create instance of SdRequestForm with received instance of SdRequest' do
          expect(SdRequestForm).to receive(:new).with(sd_request)

          context
        end
      end

      it 'set current_user into form' do
        expect(form_dbl).to receive(:current_user=).with(user)

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

      describe 'processing history' do
        let(:history) { double(:history) }
        before do
          allow(HistoryBuilder).to receive(:build).and_yield(history)
          allow(history).to receive(:set_event_type)
          allow(history).to receive(:user=)
        end

        it 'set :created event_type' do
          expect(history).to receive(:set_event_type).with(:created)

          context
        end

        it 'set current_user' do
          expect(history).to receive(:user=).with(user)

          context
        end

        it { expect(context.history_store.histories.length).to eq 1 }
      end
    end
  end
end
