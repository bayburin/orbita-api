require 'spec_helper'

RSpec.shared_examples 'requirementable' do
  context 'when Claim does not exist' do
    let!(:claim) { nil }
    # before { allow(Claim).to receive(:find_by).and_return(nil) }

    it { expect(context).to be_a_failure }
    it { expect(context.error).to eq 'Заявка не найдена' }
  end

  context 'when User does not exist' do
    let!(:user) { nil }
    # before { allow(User).to receive(:find_by).and_return(nil) }

    it { expect(context).to be_a_failure }
    it { expect(context.error).to eq 'Пользователь не найден' }
  end
end
