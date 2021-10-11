require 'rails_helper'

module JobInfo
  RSpec.describe Api, type: :model do
    subject { described_class }
    let(:server_url) { ENV['INFO_JOB_URL'] }
    before { stub_request(:get, /#{server_url}.*/).to_return(status: 200, body: '', headers: {}) }
    let(:tn) { 12345 }
    let(:start_date) { Time.zone.now }
    let(:end_date) { Time.zone.now + 2.days }
    let(:hours) { 15 }

    it 'define API_ENDPOINT constant' do
      expect(subject.const_defined?(:API_ENDPOINT)).to be_truthy
    end

    it 'included Api::V1::Connection module' do
      expect(subject.singleton_class.ancestors).to include(Connection::ClassMethods)
    end

    describe '::claim_work_time' do
      it 'sends :get request with required params' do
        subject.claim_work_time(tn, start_date, end_date)

        expect(WebMock).to have_requested(:get, /#{server_url}\/get_case_work_time\?end_date=.*&start_date=.*tn=12345/)
      end

      it 'returns instance of Faraday::Response class' do
        expect(subject.claim_work_time(tn, start_date, end_date)).to be_instance_of(Faraday::Response)
      end
    end

    describe '::claim_end_time' do
      it 'sends :get request with required params' do
        subject.claim_end_time(tn, start_date, hours)

        expect(WebMock).to have_requested(:get, /#{server_url}\/get_case_end_time\?hours=15&start_date=.*tn=12345/)
      end

      it 'returns instance of Faraday::Response class' do
        expect(subject.claim_end_time(tn, start_date, hours)).to be_instance_of(Faraday::Response)
      end
    end
  end
end
