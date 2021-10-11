require 'rails_helper'

RSpec.describe Api::V1::AttachmentsController, type: :controller do
  sign_in_user

  describe 'GET #show' do
    let(:attachment) { create(:attachment) }
    let(:params) { { claim_id: attachment.claim_id, id: attachment.id } }

    it 'sends file' do
      expect(subject).to receive(:send_file).with(attachment.attachment.file.file)

      get :show, params: params, format: :json
    end

    it 'respond with status 200' do
      get :show, params: params, format: :json

      expect(response.status).to eq 200
    end
  end
end
