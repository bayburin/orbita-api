require 'rails_helper'

module ServiceDesk
  RSpec.describe ServerApi do
    subject { described_class }

    it 'define API_ENDPOINT constant' do
      expect(subject.const_defined?(:API_ENDPOINT)).to be_truthy
    end

    it 'included Connection module' do
      expect(subject.singleton_class.ancestors).to include(Connection::ClassMethods)
    end

    describe '::ticket' do
      let(:id) { 1 }
      let(:req) { "#{ENV['SERVICE_DESK_URL']}/tickets/#{id}" }
      before { stub_request(:get, req).to_return(status: 200, body: '', headers: {}) }

      it 'sends :get request' do
        subject.ticket(id)

        expect(WebMock).to have_requested(:get, req)
      end

      it 'returns instance of Faraday::Response class' do
        expect(subject.ticket(id)).to be_instance_of(Faraday::Response)
      end
    end

    describe '::ticket_by_identity' do
      let(:identity) { 1 }
      let(:req) { "#{ENV['SERVICE_DESK_URL']}/tickets/identity/#{identity}" }
      before { stub_request(:get, req).to_return(status: 200, body: '', headers: {}) }

      it 'sends :get request' do
        subject.ticket_by_identity(identity)

        expect(WebMock).to have_requested(:get, req)
      end

      it 'returns instance of Faraday::Response class' do
        expect(subject.ticket_by_identity(identity)).to be_instance_of(Faraday::Response)
      end
    end
  end
end
