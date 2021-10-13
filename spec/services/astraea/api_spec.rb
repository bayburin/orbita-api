require 'rails_helper'

module Astraea
  RSpec.describe Api, type: :model do
    subject { described_class }
    let(:server_url) { ENV['ASTRAEA_URL'] }

    it 'define API_ENDPOINT constant' do
      expect(subject.const_defined?(:API_ENDPOINT)).to be_truthy
    end

    it 'included Api::V1::Connection module' do
      expect(subject.singleton_class.ancestors).to include(Connection::ClassMethods)
    end

    describe '::save_sd_request' do
      before { stub_request(:post, /#{server_url}.*/).to_return(status: 200, body: '', headers: {}) }

      it 'sends :post request with required params' do
        subject.save_sd_request({})

        expect(WebMock).to have_requested(:post, "#{ENV['ASTRAEA_URL']}/sd_requests.json")
      end

      it 'returns instance of Faraday::Response class' do
        expect(subject.save_sd_request({})).to be_instance_of(Faraday::Response)
      end
    end

    describe '::close_case' do
      before { stub_request(:post, /#{server_url}.*/).to_return(status: 200, body: '', headers: {}) }

      it 'sends :post request with required params' do
        subject.close_case({})

        expect(WebMock).to have_requested(:post, "#{ENV['ASTRAEA_URL']}/sd_requests.json")
      end

      it 'returns instance of Faraday::Response class' do
        expect(subject.close_case({})).to be_instance_of(Faraday::Response)
      end
    end
  end
end
