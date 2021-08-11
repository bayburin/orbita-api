require 'rails_helper'

module SdRequests
  RSpec.describe SyncWithAstraea do
    let!(:astraea_app) { create(:oauth_application, name: 'Astraea') }
    let(:user) { create(:admin) }
    let(:astraea_form_adapter_dbl) { instance_double(AstraeaFormAdapter, read_attribute_for_serialization: {}) }
    let(:sd_request) { create(:sd_request) }
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
    let(:body) { { case_id: 123 } }
    let(:response) { double(:astraea_response, success?: true, body: body.to_json) }
    before do
      allow(AstraeaFormAdapter).to receive(:new).and_return(astraea_form_adapter_dbl)
      allow(AstraeaFormAdapterSerializer).to receive(:new).with(astraea_form_adapter_dbl).and_return(json_form)
      allow(Astraea::Api).to receive(:create_sd_request).and_return(response)
    end

    describe '.call' do
      it { expect(context).to be_a_success }

      it 'call AstraeaFormAdapterSerializer serializer' do
        expect(AstraeaFormAdapterSerializer).to receive(:new).with(astraea_form_adapter_dbl)

        context
      end

      it 'call Astraea::Api.create_sd_request method' do
        expect(Astraea::Api).to receive(:create_sd_request).with(json_form, files)

        context
      end

      it 'update integration_id of sd_request' do
        context

        expect(sd_request.integration_id).to eq 123
      end

      it 'update application_id of sd_request' do
        context

        expect(sd_request.application_id).to eq astraea_app.id
      end

      context 'when Astraea::Api.create_sd_request finished with error' do
        let(:response) { double(:astraea_response, success?: false) }

        it 'does not update integration_id of sd_request' do
          context

          expect(sd_request.integration_id).to be_nil
        end

        it 'does not update application_id of sd_request' do
          context

          expect(sd_request.application_id).to be_nil
        end
      end
    end
  end
end
