require 'rails_helper'

module AuthCenter
  RSpec.describe JsonWebToken do
    subject { described_class }
    let(:payload) { { data: 'fake-data' } }

    describe '.encode' do
      let(:jwt) { 'fake-jwt' }

      it 'call "encode" method from JWT class' do
        expect(JWT).to receive(:encode).with(payload, subject::SECRET_KEY, subject::HMAC)

        subject.encode(payload)
      end

      it 'return generated jwt' do
        allow(JWT).to receive(:encode).and_return(jwt)

        expect(subject.encode(payload)).to eq(jwt)
      end
    end

    describe '.decode' do
      let(:jwt) { subject.encode(payload) }

      it 'return decoded jwt' do
        expect(subject.decode(jwt)[:data]).to eq(payload[:data])
      end
    end
  end
end
