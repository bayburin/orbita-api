require 'rails_helper'

module Api
  RSpec.describe AuthCenter do
    subject { described_class }

    it 'define API_ENDPOINT constant' do
      expect(subject.const_defined?(:API_ENDPOINT)).to be_truthy
    end

    it 'included Connection module' do
      expect(subject.singleton_class.ancestors).to include(Connection::ClassMethods)
    end

    describe '::access_token' do
      let(:auth_code) { 'fake_authorize_code' }
      let(:body) do
        {
          grant_type: 'authorization_code',
          client_id: ENV['AUTH_CENTER_APP_ID'],
          client_secret: ENV['AUTH_CENTER_APP_SECRET'],
          redirect_uri: ENV['AUTH_CENTER_APP_URL'],
          code: auth_code
        }
      end

      before do
        stub_request(:post, "#{ENV['AUTH_CENTER_URL']}/oauth/token").to_return(status: 200, body: '', headers: {})
      end

      it 'sends :post request with required params in body' do
        subject.access_token(auth_code)

        expect(WebMock).to have_requested(:post, "#{ENV['AUTH_CENTER_URL']}/oauth/token").with(body: body.to_json)
      end

      it 'returns instance of Faraday::Response class' do
        expect(subject.access_token(auth_code)).to be_instance_of(Faraday::Response)
      end
    end

    describe '::user_info' do
      let(:access_token) { 'fake_access_token' }
      let(:headers) { { 'Authorization' => "Bearer #{access_token}" } }
      let(:req) { "#{ENV['AUTH_CENTER_URL']}#{ENV['AUTH_CENTER_LOGIN_INFO']}" }

      before do
        stub_request(:get, req).to_return(status: 200, body: '', headers: {})
      end

      it 'sends :get request with required headers' do
        subject.login_info(access_token)

        expect(WebMock).to have_requested(:get, req).with(headers: headers)
      end

      it 'returns instance of Faraday::Response class' do
        expect(subject.login_info(access_token)).to be_instance_of(Faraday::Response)
      end
    end

    describe '::login_info' do
      let(:access_token) { 'fake_access_token' }
      let(:headers) { { 'Authorization' => "Bearer #{access_token}" } }
      let(:params) { { id: 'invent_num', idfield: 'name' } }
      let(:req) { "#{ENV['AUTH_CENTER_URL']}#{ENV['AUTH_CENTER_HOST_INFO']}?id=#{params[:id]}&idfield=#{params[:idfield]}" }

      before do
        stub_request(:get, req).to_return(status: 200, body: '', headers: {})
      end

      it 'sends :get request with required headers' do
        subject.host_info(access_token, params[:id], params[:idfield])

        expect(WebMock).to have_requested(:get, req).with(headers: headers)
      end

      it 'set default :idfield attribute' do
        stub_request(:get, "#{ENV['AUTH_CENTER_URL']}#{ENV['AUTH_CENTER_HOST_INFO']}?id=#{params[:id]}&idfield=id").to_return(status: 200, body: '', headers: {})
        subject.host_info(access_token, params[:id])

        expect(WebMock).to have_requested(:get, "#{ENV['AUTH_CENTER_URL']}#{ENV['AUTH_CENTER_HOST_INFO']}?id=#{params[:id]}&idfield=id").with(headers: headers)
      end

      it 'returns instance of Faraday::Response class' do
        expect(subject.host_info(access_token, params[:id], params[:idfield])).to be_instance_of(Faraday::Response)
      end
    end
  end
end
