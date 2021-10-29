require 'rails_helper'

module Events
  RSpec.describe Api, type: :model do
    let(:endpoint) { 'https://fake-endpoint' }
    let(:value) { true }
    let(:comment) { 'fake-comment' }
    subject { described_class }

    describe '::send_user_answer' do
      before { stub_request(:post, endpoint).to_return(status: 200, body: '', headers: {}) }

      it 'sends :post request with required params' do
        subject.send_user_answer(endpoint, value, comment)

        expect(WebMock).to have_requested(:post, endpoint)
      end

      it 'returns instance of Faraday::Response class' do
        expect(subject.send_user_answer(endpoint, value, comment)).to be_instance_of(Faraday::Response)
      end
    end
  end
end
