require 'rails_helper'

module AuthCenter
  RSpec.describe AppTokenCache do
    subject { described_class }

    describe '::token' do
      context 'when token saved into redis' do
        let(:token) { { access_token: 'fake-token' } }
        before { allow(ReadCache.redis).to receive(:get).and_return(Oj.dump(token)) }

        it { expect(subject.token).to be_instance_of AuthCenterToken }
        it { expect(subject.token.access_token).to eq token[:access_token] }
      end

      context 'when token is not exist' do
        before { allow(ReadCache.redis).to receive(:get) }

        it { expect(subject.token).to be_nil }
      end
    end

    describe '::token=' do
      let(:token) { { token: '123' } }

      it 'call ReadCache.redis.set method' do
        expect(ReadCache.redis).to receive(:set).with(subject::TOKEN_NAME, Oj.dump(token))

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
