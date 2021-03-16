require 'rails_helper'

module Employees
  RSpec.describe TokenCache do
    let(:token) { 'fake-token' }
    subject { described_class }

    describe '::token' do
      before { allow(ReadCache.redis).to receive(:get).and_return(token) }

      it { expect(subject.token).to eq token }
    end

    describe '::token=' do
      it 'call ReadCache.redis.set method' do
        expect(ReadCache.redis).to receive(:set).with(subject::TOKEN_NAME, token)

        subject.token = token
      end
    end

    describe '::clear' do
      it 'call ReadCache.redis.del method' do
        expect(ReadCache.redis).to receive(:del)

        subject.clear
      end
    end
  end
end
