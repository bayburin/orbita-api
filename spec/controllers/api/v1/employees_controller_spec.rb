require 'rails_helper'

RSpec.describe Api::V1::EmployeesController, type: :controller do
  sign_in_user

  describe 'GET #index' do
    let(:params) { { key: 'personnelNo', value: '1234' } }
    let(:api_response) { { data: [] }.as_json }

    before(:each) { allow_any_instance_of(Employees::Employee).to receive(:load).and_return(api_response) }

    it 'call Employees::Employee.load method' do

      expect_any_instance_of(Employees::Employee).to receive(:load).with({ field: params[:key], term: params[:value] })

      get :index, params: params
    end

    it 'respond with success status if Employees::Employee.load method return data' do
      get :index

      expect(response.status).to eq 200
    end

    it 'respond with 503 status if Employees::Employee.load method return nil' do
      allow_any_instance_of(Employees::Employee).to receive(:load).and_return(nil)
      get :index

      expect(response.status).to eq 503
    end
  end
end
