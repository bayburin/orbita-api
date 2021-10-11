require 'rails_helper'

RSpec.describe Api::V1::CommentsController, type: :controller do
  sign_in_user

  describe 'POST #create' do
    let!(:sd_request) { create(:sd_request) }
    let(:params) { { claim_id: sd_request.id } }
    before { allow(Comments::Create).to receive(:call).and_return(create_form_dbl) }

    context 'when form saved data' do
      let(:create_form_dbl) { double(:create_form, success?: true) }

      it 'call Comments::Create.call method' do
        expect(Comments::Create).to receive(:call).and_return(create_form_dbl)

        post :create, params: params
      end

      it 'respond with success status' do
        post :create, params: params

        expect(response.status).to eq 200
      end
    end

    context 'when form finished with fail' do
      let(:create_form_dbl) { double(:create_form, success?: false, error: 'errors') }

      it 'respond with error status' do
        post :create, params: params

        expect(response.status).to eq 400
      end

      it 'respond with error' do
        post :create, params: params

        expect(response.body).to eq(create_form_dbl.error)
      end
    end
  end
end
