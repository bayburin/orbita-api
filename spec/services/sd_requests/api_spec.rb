require 'rails_helper'

module SdRequests
  RSpec.describe Api, type: :model do
    let(:url) { 'https://fake-url' }
    let(:sd_request) { create(:sd_request) }
    subject { described_class }

    describe '::create' do
      before { stub_request(:post, /#{url}.*/).to_return(status: 200, body: '', headers: {}) }

      it 'sends :post request with required params' do
        subject.create(url, sd_request, {})

        expect(WebMock).to have_requested(:post, url)
      end

      it 'returns instance of Faraday::Response class' do
        expect(subject.create(url, sd_request, {})).to be_instance_of(Faraday::Response)
      end
    end
  end
end
