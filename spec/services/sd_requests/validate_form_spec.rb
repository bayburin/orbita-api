require 'rails_helper'

module SdRequests
  RSpec.describe ValidateForm do
    let(:sd_request) { build(:sd_request) }
    let(:user) { create(:admin) }
    let(:params) { { foo: :bar, attachments: [{ attachment: 'fake-attachment' }] } }
    let(:history_store_dbl) { instance_double('Histories::Storage') }
    let(:error_dbl) { double(:error, messages: []) }
    let(:form_dbl) { instance_double('SdRequestForm', validate: true, errors: error_dbl) }
    subject(:context) { described_class.call(params: params, current_user: user, form: form_dbl, new_files: nil) }
    before do
      allow(form_dbl).to receive(:current_user=)
      allow(form_dbl).to receive(:history_store=)
      allow(Histories::Storage).to receive(:new).and_return(history_store_dbl)
    end

    describe '.call' do
      it { expect(context).to be_a_success }

      it 'create Histories::Storage instance' do
        expect(Histories::Storage).to receive(:new).with(user).and_return(history_store_dbl)

        context
      end

      it 'set current_user into form' do
        expect(form_dbl).to receive(:current_user=).with(user)

        context
      end

      it 'set history_store into form' do
        expect(form_dbl).to receive(:history_store=).with(history_store_dbl)

        context
      end

      context 'when new_files array has any file' do
        let(:file) do
          ActionDispatch::Http::UploadedFile.new(
            filename: 'fake-file',
            type: 'text/plain',
            tempfile: File.open(Rails.root.join('spec', 'uploads', 'test_file.txt'))
          )
        end
        let(:new_files) { [{ attachment: file }] }
        before do
          params[:attachments] = params[:attachments].concat(new_files)
        end

        it 'add new files to params' do
          expect(form_dbl).to receive(:validate).with(params)

          context
        end
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
