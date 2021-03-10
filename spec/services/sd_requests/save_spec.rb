require 'rails_helper'

module SdRequests
  RSpec.describe Save do
    let(:created_sd_request) { create(:sd_request) }
    let(:work) { create(:work) }
    let(:create_form_dbl) { double(:create_form, save: true, model: created_sd_request, errors: {}) }
    let(:history_store_dbl) { double(:history_store, histories: [], save!: true) }
    let(:user) { create(:admin) }
    subject(:context) do
      described_class.call(
        create_form: create_form_dbl,
        history_store: history_store_dbl,
        current_user: user
      )
    end
    before do
      allow(history_store_dbl).to receive(:work=)
      allow(created_sd_request).to receive(:work_for).and_return(work)
    end

    describe '.call' do
      it { expect(context).to be_a_success }

      it 'call #save method for create_form object' do
        expect(create_form_dbl).to receive(:save)

        context
      end

      it 'set work into history_store' do
        expect(history_store_dbl).to receive(:work=).with(work)

        context
      end

      it 'call #save! method for history_store' do
        expect(history_store_dbl).to receive(:save!)

        context
      end

      it { expect(context.sd_request).to eq created_sd_request }

      context 'when form was not saved' do
        before { allow(create_form_dbl).to receive(:save).and_return(false) }

        it { expect(context).to be_a_failure }

        it 'does not call #save! method for history_store' do
          expect(history_store_dbl).not_to receive(:save!)

          context
        end
      end

      context 'when history was not saved' do
        before { allow(history_store_dbl).to receive(:save!).and_raise(ActiveRecord::RecordNotSaved) }

        it { expect(context).to be_a_failure }
      end
    end
  end
end
