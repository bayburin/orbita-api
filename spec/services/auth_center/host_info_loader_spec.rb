require 'rails_helper'

module AuthCenter
  RSpec.describe HostInfoLoader do
    it 'sets zero to the @counter variable' do
      expect(subject.instance_variable_get(:@counter)).to be_zero
    end

    describe '#load' do
      let(:data) { { data: { foo: :bar } } }
      let(:response) { double('response', status: 200, body: data.as_json, success?: true) }
      let(:value) { '12345' }
      let(:access_token) { 'fake-token' }
      let(:token_dbl) { double(:token, access_token: access_token) }
      let(:app_token_dbl) { double(:app_token, success?: true, token: token_dbl) }
      before do
        allow(AppToken).to receive(:call).and_return(app_token_dbl)
        allow(AuthCenter::Api).to receive(:host_info).and_return(response)
      end

      context 'when search_key is not empty' do
        let(:search_key) { 'fake-key' }

        it 'set into "search_key" received value' do
          expect(AuthCenter::Api).to receive(:host_info).with(access_token, value, search_key).and_return(response)

          subject.load(value, search_key)
        end
      end

      it 'set into "search_key" default value' do
        expect(AuthCenter::Api).to receive(:host_info).with(access_token, value, 'id').and_return(response)

        subject.load(value)
      end

      context 'when @counter is equal its max value' do
        before { subject.instance_variable_set(:@counter, 2) }

        it 'returns nil' do
          expect(subject.load(value)).to be_nil
        end

        it 'sets zero to @counter variable' do
          subject.load(value)

          expect(subject.instance_variable_get(:@counter)).to be_zero
        end
      end

      context 'when UserRequestSwitcher.request finished with failure' do
        let(:response) { double('response', status: 401, body: data, success?: false) }

        it 'calls #load max times' do
          expect(subject).to receive(:load).exactly(HostInfoLoader::STOP_COUNTER - 1).times

          subject.load(value)
        end

        it 'calls Employees::TokenCache.clear method' do
          expect(AuthCenter::AppTokenCache).to receive(:clear).exactly(HostInfoLoader::STOP_COUNTER).times

          subject.load(value)
        end
      end

      it 'returns occured data' do
        expect(subject.load(value)).to eq data.as_json
      end
    end
  end
end
