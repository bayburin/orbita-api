require 'rails_helper'

module Comments
  RSpec.describe Create do
    subject(:context) { described_class.call }
    before do
      allow(Save).to receive(:call!).and_return(true)
      allow(Astraea::AddComment).to receive(:call!).and_return(true)
    end

    describe '.call' do
      it { expect(context).to be_a_success }
    end
  end
end
