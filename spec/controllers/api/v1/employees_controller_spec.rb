require 'rails_helper'

RSpec.describe Api::V1::EmployeesController, type: :controller do
  sign_in_user

  describe 'GET #index' do
    let(:filters) { { key: 'personnelNo', value: '1234' } }
    let(:params) { { filters: { key: 'personnelNo', value: '1234' }.to_json } }
    let(:data) { [{ fio: 'first' }, { fio: 'second' }] }
    let(:search_dbl) { double('search', success?: true, employees: data.as_json) }
    before(:each) { allow(Employees::Search).to receive(:call).and_return(search_dbl) }

    it 'call Employees::Search method' do
      expect(Employees::Search).to receive(:call).with(filters: filters.as_json)

      get :index, params: params
    end

    it 'respond with finded data' do
      get :index, params: params

      expect(parse_json(response.body)['employees']).to eq data.as_json
    end

    it 'respond with success status if Employees::Loader.load method return data' do
      get :index, params: params

      expect(response.status).to eq 200
    end

    it 'respond with 503 status if Employees::Search class finished with failure' do
      allow(search_dbl).to receive(:success?).and_return(false)
      get :index, params: params

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

      expect(parse_json(response.body)).to eq api_response.as_json
    end

    it 'respond with empty object if data not found' do
      allow_any_instance_of(Employees::Loader).to receive(:load).and_return(nil)
      get :show, params: params

      expect(parse_json(response.body)).to eq({})
    end

    it 'respond with success status if Employees::Loader.load method return data' do
      get :show, params: params

      expect(response.status).to eq 200
    end
  end
end
