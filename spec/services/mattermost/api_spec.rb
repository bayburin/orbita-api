require 'rails_helper'

module Mattermost
  RSpec.describe Api do
    subject { described_class }

    it 'define API_ENDPOINT constant' do
      expect(subject.const_defined?(:API_ENDPOINT)).to be_truthy
    end

    it 'included Connection module' do
      expect(subject.singleton_class.ancestors).to include(Connection::ClassMethods)
    end

    describe '::notify' do
      let(:channel) { '@test_channel' }
      let(:message) { 'test message' }
      let(:body) do
        {
          channel: channel,
          text: message
        }
      end
      before do
        stub_request(:post, ENV['MATTERMOST_NOTIFIER_URL']).to_return(status: 200, body: '', headers: {})
      end

      it 'sends :post request with required params in body' do
        subject.notify(channel, message)

        expect(WebMock).to have_requested(:post, ENV['MATTERMOST_NOTIFIER_URL']).with(body: body.to_json)
      end

      it 'returns instance of Faraday::Response class' do
        expect(subject.notify(channel, message)).to be_instance_of(Faraday::Response)
      end
    end
  end
end
