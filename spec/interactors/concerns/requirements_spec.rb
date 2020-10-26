require 'spec_helper'

shared_examples_for 'requirementable' do
  context 'when Claim does not exist' do
    before { allow(Claim).to receive(:find_by).and_return(nil) }

    it { expect(context).to be_a_failure }
    it { expect(context.error).to eq 'Заявка не найдена' }
  end

  context 'when User does not exist' do
    before { allow(User).to receive(:find_by).and_return(nil) }

    it { expect(context).to be_a_failure }
    it { expect(context.error).to eq 'Пользователь не найден' }
  end
end
