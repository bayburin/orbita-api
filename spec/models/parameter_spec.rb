require 'rails_helper'

RSpec.describe Parameter, type: :model do
  it { is_expected.to belong_to(:claim) }

  describe '#payload_data' do
    let(:double) { instance_double('ParameterSchema::V1') }

    it 'call ParameterSchema::V1' do
      expect(ParameterSchema::V1).to receive(:new).with(subject.payload)

      subject.payload_data
    end

    it { expect(subject.payload_data).to be_instance_of ParameterSchema::V1 }
  end
end
