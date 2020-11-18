require 'rails_helper'

module Applications
  RSpec.describe Create do
    let(:created_application) { create(:application) }
    let(:application_params) { { } }
    let(:create_form_dbl) { double(:create_form, validate: true, save: true, model: created_application) }
    subject(:context) { described_class.call(params: application_params) }
    before { allow(ApplicationForm).to receive(:new).and_return(create_form_dbl) }

    describe '.call' do
      it { expect(context).to be_a_success }
      it { expect(context.application).to eq created_application }

      it 'create instance of ApplicationForm' do
        expect(ApplicationForm).to receive(:new).with(an_instance_of(Application))

        context
      end

      context 'when context.application exist' do
        let(:application) { Application.new(attrs: { foo: :bar }) }
        subject(:context) { described_class.call(params: application_params, application: application) }

        it 'create instance of ApplicationForm with received instance of Application' do
          expect(ApplicationForm).to receive(:new).with(application)

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
