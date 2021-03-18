require 'rails_helper'

module Employees
  RSpec.describe Loader do
    let(:type) { 'custom_type' }
    subject { described_class.new(type) }

    it 'sets zero to the @counter variable' do
      expect(subject.instance_variable_get(:@counter)).to be_zero
    end

    describe '#load' do
      let(:params) { 'any_params' }
      let(:data) { { data: [] }.as_json }
      let(:response) { double('response', status: 200, body: data, success?: true) }
      let(:token) { 'fake-token' }
      before do
        allow(TokenCache).to receive(:token).and_return(token)
        allow(UserRequestSwitcher).to receive(:request).and_return(response)
      end

      context 'when TokenCache is empty' do
        let(:authorize_dbl) { double(:authorize, success?: true, token: token) }
        before do
          allow(TokenCache).to receive(:token).and_return(nil)
          allow(Authorize).to receive(:call).and_return(authorize_dbl)
        end

        it 'call Authorize.call method' do
          expect(Authorize).to receive(:call)

          subject.load(params)
        end

        it 'call UserRequestSwitcher with new token' do
          expect(UserRequestSwitcher).to receive(:request).with(type, token, params).and_return(response)

          subject.load(params)
        end

        context 'and when Authorize.call finished failure' do
          let(:authorize_dbl) { double(:authorize, success?: false, error: {}) }

          it { expect { subject.load(params) }.to raise_error(RuntimeError) }
        end
      end

      context 'when @counter is equal its max value' do
        before { subject.instance_variable_set(:@counter, 2) }

        it 'returns nil' do
          expect(subject.load(params)).to be_nil
        end

        it 'sets zero to @counter variable' do
          subject.load(params)

          expect(subject.instance_variable_get(:@counter)).to be_zero
        end
      end

      context 'when UserRequestSwitcher.request finished with failure' do
        let(:response) { double('response', status: 401, body: data, success?: false) }
        before { allow(UserRequestSwitcher).to receive(:request).with(type, token, params).and_return(response) }

        it 'calls #load max times' do
          expect(subject).to receive(:load).exactly(Loader::STOP_COUNTER - 1).times

          subject.load(params)
        end

        it 'calls Employees::TokenCache.clear method' do
          expect(Employees::TokenCache).to receive(:clear).exactly(Loader::STOP_COUNTER).times

          subject.load(params)
        end
      end

      it 'returns occured data' do
        expect(subject.load(params)).to eq data
      end
    end
  end
end
