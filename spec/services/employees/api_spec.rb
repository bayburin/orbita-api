require 'rails_helper'

module Employees
  RSpec.describe Api, type: :model do
    subject { described_class }
    let(:token) { 'custom_token' }
    let(:server_url) { "#{ENV['EMPLOYEE_DATABASE_URL']}/emp" }
    before { stub_request(:get, /#{server_url}.*/).to_return(status: 200, body: '', headers: {}) }

    it 'define API_ENDPOINT constant' do
      expect(subject.const_defined?(:API_ENDPOINT)).to be_truthy
    end

    it 'included Api::V1::Connection module' do
      expect(subject.singleton_class.ancestors).to include(Connection::ClassMethods)
    end

    describe '::token' do
      let(:username) { 'username' }
      let(:password) { 'password' }
      before { stub_request(:post, "#{ENV['EMPLOYEE_DATABASE_URL']}/login").to_return(status: 200, body: '', headers: {}) }

      it 'sends :post request with required headers' do
        ENV['EMPLOYEE_DATABASE_USERNAME'] = username
        ENV['EMPLOYEE_DATABASE_PASSWORD'] = password
        subject.token

        expect(WebMock).to have_requested(:post, "#{ENV['EMPLOYEE_DATABASE_URL']}/login")
                             .with(headers: { 'X-Auth-Username': username, 'X-Auth-Password': password })
      end

      it 'returns instance of Faraday::Response class' do
        expect(subject.token).to be_instance_of(Faraday::Response)
      end
    end

    describe '::load_user' do
      it 'sends :get request with required params and headers' do
        subject.load_user(token, 123)

        expect(WebMock).to have_requested(:get, "#{ENV['EMPLOYEE_DATABASE_URL']}/emp/123")
                             .with(headers: { 'X-Auth-Token': token })
      end

      it 'returns instance of Faraday::Response class' do
        expect(subject.load_user(token, 123)).to be_instance_of(Faraday::Response)
      end
    end

    describe '::load_users_by_id_tn' do
      it 'sends :get request with required params and headers' do
        subject.load_users_by_id_tn(token, [123])

        expect(WebMock).to have_requested(:get, "#{ENV['EMPLOYEE_DATABASE_URL']}/emp?search=id=in=(123)")
                             .with(headers: { 'X-Auth-Token': token })
      end

      it 'returns instance of Faraday::Response class' do
        expect(subject.load_users_by_id_tn(token, [123])).to be_instance_of(Faraday::Response)
      end
    end

    describe '::load_users_by_tn' do
      it 'sends :get request with required params and headers' do
        subject.load_users_by_tn(token, [123])

        expect(WebMock).to have_requested(:get, "#{ENV['EMPLOYEE_DATABASE_URL']}/emp?search=personnelNo=in=(123)")
                             .with(headers: { 'X-Auth-Token': token })
      end

      it 'returns instance of Faraday::Response class' do
        expect(subject.load_users_by_tn(token, [123])).to be_instance_of(Faraday::Response)
      end
    end

    describe '::load_users_like' do
      it 'sends :get request with required params and headers' do
        subject.load_users_like(token, :personnelNo, 12_345)

        expect(WebMock).to have_requested(:get, "#{ENV['EMPLOYEE_DATABASE_URL']}/emp?search=personnelNo=='*12345*'")
                             .with(headers: { 'X-Auth-Token': token })
      end

      it 'returns instance of Faraday::Response class' do
        expect(subject.load_users_like(token, :personnelNo, 12_345)).to be_instance_of(Faraday::Response)
      end
    end

    describe '::search' do
      let(:filters) { "foo='bar'" }

      it 'sends :get request with required params and headers' do
        subject.search(token, filters)

        expect(WebMock).to have_requested(:get, "#{ENV['EMPLOYEE_DATABASE_URL']}/emp?search=#{filters}")
                             .with(headers: { 'X-Auth-Token': token })
      end

      it 'returns instance of Faraday::Response class' do
        expect(subject.search(token, filters)).to be_instance_of(Faraday::Response)
      end
    end
  end
end
