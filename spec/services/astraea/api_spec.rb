require 'rails_helper'

module Astraea
  RSpec.describe Api, type: :model do
    subject { described_class }
    let(:server_url) { ENV['ASTRAEA_URL'] }
    before { stub_request(:post, /#{server_url}.*/).to_return(status: 200, body: '', headers: {}) }

    it 'define API_ENDPOINT constant' do
      expect(subject.const_defined?(:API_ENDPOINT)).to be_truthy
    end

    it 'included Api::V1::Connection module' do
      expect(subject.singleton_class.ancestors).to include(Connection::ClassMethods)
    end

    describe '::create_sd_request' do
      it 'sends :post request with required params' do
        subject.create_sd_request({})

        expect(WebMock).to have_requested(:post, "#{ENV['ASTRAEA_URL']}/sd_requests.json")
      end

      it 'returns instance of Faraday::Response class' do
        expect(subject.create_sd_request({})).to be_instance_of(Faraday::Response)
      end
    end
  end
end
