require 'rails_helper'

RSpec.describe Api::V1::ClaimsController, type: :controller do
  sign_in_user

  # describe 'GET #index' do
  #   before do
  #     create_list(:sd_request, 2)
  #     create_list(:case, 2)
  #   end

  #   it 'repond with all claims' do
  #     get :index

  #     expect(response.body).to have_json_size(2)
  #     expect(response.body).to have_json_size(SdRequest.count).at_path('sd_requests')
  #     expect(response.body).to have_json_size(Case.count).at_path('cases')
  #   end

  #   it 'respond with success status' do
  #     get :index

  #     expect(response.status).to eq 200
  #   end
  # end
end
