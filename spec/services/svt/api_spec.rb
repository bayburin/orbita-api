require 'rails_helper'

module Svt
  RSpec.describe Api, type: :model do
    subject { described_class }
    let(:server_url) { ENV['SVT_URL'] }
    before { stub_request(:get, /#{server_url}.*/).to_return(status: 200, body: '', headers: {}) }

    it 'define API_ENDPOINT constant' do
      expect(subject.const_defined?(:API_ENDPOINT)).to be_truthy
    end

    it 'included Api::V1::Connection module' do
      expect(subject.singleton_class.ancestors).to include(Connection::ClassMethods)
    end

    describe '::find_by_barcode' do
      it 'sends :get request with required params' do
        subject.find_by_barcode(123)

        expect(WebMock).to have_requested(:get, "#{ENV['SVT_URL']}/api/v2/invent/items/123")
      end

      it 'returns instance of Faraday::Response class' do
        expect(subject.find_by_barcode(123)).to be_instance_of(Faraday::Response)
      end
    end

    describe '::query_items' do
      let(:params) { { foo: 'bar' } }

      it 'sends :get request with required params' do
        subject.query_items(params)

        expect(WebMock).to have_requested(:get, "#{ENV['SVT_URL']}/api/v2/invent/search_items?foo=bar")
      end

      it 'returns instance of Faraday::Response class' do
        expect(subject.query_items(params)).to be_instance_of(Faraday::Response)
      end
    end
  end
end
