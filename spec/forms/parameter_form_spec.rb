require 'rails_helper'

RSpec.describe ParameterForm, type: :model do
  subject { described_class.new(Parameter.new) }

  describe 'validations' do
    context 'when name is empty' do
      before { subject.validate(name: '') }

      it { expect(subject.errors.messages).to include(:name) }
      it { expect(subject.errors.messages[:name]).to include('не может быть пустым') }
    end
  end
end
