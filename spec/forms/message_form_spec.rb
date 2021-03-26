require 'rails_helper'

RSpec.describe MessageForm, type: :model do
  subject { described_class.new(Message.new) }
  let(:params) { { comment: attributes_for(:comment) } }

  describe 'validations' do
    context 'when comment is empty' do
      before { subject.validate({ comment: '' }) }

      it { expect(subject.errors.messages).to include(:message) }
      it { expect(subject.errors.messages[:message]).to include('не может быть пустым') }
    end
  end
end
