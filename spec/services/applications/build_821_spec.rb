require 'rails_helper'

module Applications
  RSpec.describe Build821 do
    let(:application) { build(:application) }
    subject(:context) { described_class.call(params: {}) }
    before do
      allow(ApplicationBuilder).to receive(:build).and_return(application)
      allow(SourceSnapshotBuilder).to receive(:build).and_return(application.source_snapshot)
    end

    describe '.call' do
      it { expect(context.application).to be_instance_of Application }
      it { expect(context).to be_a_success }
    end
  end
end
