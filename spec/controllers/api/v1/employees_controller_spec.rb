require 'rails_helper'

RSpec.describe Api::V1::EmployeesController, type: :controller do
  sign_in_user

  describe 'GET #index' do
    let(:params) { { key: 'personnelNo', value: '1234' } }
    let(:api_response) { { data: [{ fio: 'first' }, { fio: 'second' }] } }
    before(:each) { allow_any_instance_of(Employees::Loader).to receive(:load).and_return(api_response.as_json) }

    it 'call Employees::Loader.load method' do
      expect_any_instance_of(Employees::Loader).to receive(:load).with(field: params[:key], term: params[:value])

      get :index, params: params
    end

    it 'respond with finded data' do
      get :index

      expect(parse_json(response.body)['employees']).to eq api_response[:data].as_json
    end

    it 'respond with success status if Employees::Loader.load method return data' do
      get :index

      expect(response.status).to eq 200
    end

    it 'respond with 503 status if Employees::Loader.load method return nil' do
      allow_any_instance_of(Employees::Loader).to receive(:load).and_return(nil)
      get :index

      expect(response.status).to eq 503
    end
  end

  describe 'GET #show' do
    let(:params) { { id: '123' } }
    let(:api_response) { { fio: 'first' } }
    before(:each) { allow_any_instance_of(Employees::Loader).to receive(:load).and_return(api_response.as_json) }

    it 'call Employees::Loader.load method' do
      expect_any_instance_of(Employees::Loader).to receive(:load).with(params[:id])

      get :show, params: params
    end

    it 'respond with finded data' do
      get :show, params: params

      expect(parse_json(response.body)['employee']).to eq api_response.as_json
    end

    it 'respond with success status if Employees::Loader.load method return data' do
      get :show, params: params

      expect(response.status).to eq 200
    end

    it 'respond with 503 status if Employees::Loader.load method return nil' do
      allow_any_instance_of(Employees::Loader).to receive(:load).and_return(nil)
      get :show, params: params

      expect(response.status).to eq 503
    end
  end
end
