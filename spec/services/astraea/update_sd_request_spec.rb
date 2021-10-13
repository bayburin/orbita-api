require 'rails_helper'

module Astraea
  RSpec.describe UpdateSdRequest do
    let(:user) { create(:admin) }
    let(:astraea_form_adapter_dbl) { instance_double(FormAdapter, read_attribute_for_serialization: {}) }
    let(:sd_request) { create(:sd_request, integration_id: 12345) }
    let(:form_dbl) { double(:form, model: sd_request) }
    let(:json_form) { { foo: 'bar' }.as_json }
    let(:files) do
      [
        ActionDispatch::Http::UploadedFile.new(
          filename: 'fake-file',
          type: 'text/plain',
          tempfile: File.open(Rails.root.join('spec', 'uploads', 'test_file.txt'))
        )
      ]
    end
    subject(:context) do
      described_class.call(
        form: form_dbl,
        current_user: user,
        new_files: files
      )
    end
    let(:response) { double(:astraea_response, success?: true, body: {}) }
    before do
      allow(FormAdapter).to receive(:new).with(form_dbl, user, 'update').and_return(astraea_form_adapter_dbl)
      allow(FormAdapterSerializer).to receive(:new).with(astraea_form_adapter_dbl).and_return(json_form)
      allow(Api).to receive(:save_sd_request).and_return(response)
    end

    describe '.call' do
      it { expect(context).to be_a_success }

      it 'call FormAdapterSerializer serializer' do
        expect(FormAdapterSerializer).to receive(:new).with(astraea_form_adapter_dbl)

        context
      end

      it 'call Api.save_sd_request method' do
        expect(Api).to receive(:save_sd_request).with(json_form, files)

        context
      end

      context 'when Api raise connection error' do
        before { allow(Api).to receive(:save_sd_request).and_raise(Faraday::ConnectionFailed, 'Failed to open TCP connection') }

        it { expect(context).to be_a_success }
      end
    end
  end
end
