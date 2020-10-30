require 'rails_helper'

RSpec.describe WorkBuilder do
  include_examples 'application builder', Work

  describe 'instance methods' do
    let(:attr) { attributes_for(:work, attrs: { foo: :bar }.as_json) }
    subject { described_class.new }

    describe '#title=' do
      before { subject.title = attr[:title] }

      it { expect(subject.model.title).to eq attr[:title] }
    end

    describe '#status=' do
      before { subject.status = attr[:status] }

      it { expect(subject.model.status).to eq attr[:status] }
    end

    describe '#attrs=' do
      before { subject.attrs = attr[:attrs] }

      it { expect(subject.model.attrs).to eq attr[:attrs] }
    end
  end
end
