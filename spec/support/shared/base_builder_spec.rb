RSpec.shared_examples 'base builder' do |klass|
  describe 'class methods' do
    subject { described_class }

    describe '.build' do
      it "return instance of #{described_class.name}" do
        expect(subject.build).to be_instance_of(klass)
      end

      it { expect { |b| described_class.build(&b) }.to yield_control }
    end
  end
end
