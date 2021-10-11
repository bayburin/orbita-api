require 'spec_helper'

RSpec.shared_examples 'requirementable' do
  context 'when Claim does not exist' do
    before { allow(event).to receive(:claim).and_return(nil) }

    it { expect(context).to be_a_failure }
    it { expect(context.error).to eq 'Заявка не найдена' }
  end

  context 'when User does not exist' do
    before { allow(event).to receive(:user).and_return(nil) }

    it { expect(context).to be_a_failure }
    it { expect(context.error).to eq 'Пользователь не найден' }
  end

  it { expect(context.history_store).to be_instance_of(Histories::Storage) }
end
