require 'rails_helper'

RSpec.describe WorkBuilder do
  describe 'class methods' do
    subject { described_class }

    describe '.build' do
      it 'return instance of Work' do
        expect(subject.build).to be_instance_of(Work)
      end

      specify { expect { |b| described_class.build(&b) }.to yield_control }
    end
  end

  describe 'instance methods' do
    let(:attr) { attributes_for(:work, attrs: { foo: :bar }.as_json) }
    subject { described_class.new }

    describe '#title=' do
      before { subject.title = attr[:title] }

      it { expect(subject.work.title).to eq attr[:title] }
    end

    describe '#status=' do
      before { subject.status = attr[:status] }

      it { expect(subject.work.status).to eq attr[:status] }
    end

    describe '#attrs=' do
      before { subject.attrs = attr[:attrs] }

      it { expect(subject.work.attrs).to eq attr[:attrs] }
    end
  end
end
