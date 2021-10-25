require 'rails_helper'

RSpec.describe ServiceDesk::Api::V1::LkController, type: :controller do
  sign_in_employee

  describe 'POST #create_svt_item_request' do
    let(:user) { create(:admin) }
    let(:params) do
      {
        id_tn: user.id_tn,
        sd_request: '{}',
        new_attachments: []
      }
    end
    let!(:sd_request) { create(:sd_request) }
    before { allow(ServiceDesk::Lk::CreateSvtItemRequest).to receive(:call).and_return(create_form_dbl) }

    context 'when form saved data' do
      let(:create_form_dbl) { double(:create_form, success?: true, sd_request: sd_request) }

      it 'call ServiceDesk::Lk::CreateSvtItemRequest.call method' do
        expect(ServiceDesk::Lk::CreateSvtItemRequest).to receive(:call).and_return(create_form_dbl)

        post :create_svt_item_request, params: params
      end

      it 'respond with success status' do
        post :create_svt_item_request, params: params

        expect(response.status).to eq 200
      end
    end

    context 'when form finished with fail' do
      let(:create_form_dbl) { double(:create_form, success?: false, error: 'errors') }

      it 'respond with error status' do
        post :create_svt_item_request, params: params

        expect(response.status).to eq 400
      end

      it 'respond with error' do
        post :create_svt_item_request, params: params

        expect(response.body).to eq(create_form_dbl.error)
      end
    end
  end
end
