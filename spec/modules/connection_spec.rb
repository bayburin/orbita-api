require 'rails_helper'

class FooClass
  API_ENDPOINT = 'http://test_url'.freeze

  include Connection
end

RSpec.describe Connection do
  describe 'instance method' do
    subject { FooClass.new }

    describe '#multipart_connect' do
      it 'returns instance of Faraday' do
        expect(subject.multipart_connect).to be_instance_of(Faraday::Connection)
      end
    end

    describe '#connect' do
      it 'returns instance of Faraday' do
        expect(subject.connect).to be_instance_of(Faraday::Connection)
      end
    end
  end

  describe 'class method' do
    subject { FooClass }

    describe '.multipart_connect' do
      it 'returns instance of Faraday' do
        expect(subject.multipart_connect).to be_instance_of(Faraday::Connection)
      end
    end

    describe '.connect' do
      it 'returns instance of Faraday' do
        expect(subject.connect).to be_instance_of(Faraday::Connection)
      end
    end
  end
end
