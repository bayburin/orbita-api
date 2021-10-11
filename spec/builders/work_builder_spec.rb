require 'rails_helper'

RSpec.describe WorkBuilder do
  include_examples 'base builder', Work

  describe 'instance methods' do
    let(:attr) { attributes_for(:work, attrs: { foo: :bar }.as_json) }
    subject { described_class.new }
  end
end
