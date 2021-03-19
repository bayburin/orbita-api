require 'rails_helper'

RSpec.describe SdRequestBuilder do
  include_examples 'base builder', SdRequest

  describe 'instance methods' do
    let(:attr) { attributes_for(:sd_request, attrs: { foo: :bar }) }
    subject { described_class.new }
  end
end
