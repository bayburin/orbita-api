require 'rails_helper'

RSpec.describe Parameter, type: :model do
  it { is_expected.to belong_to(:claim) }

  describe '#payload_data' do
    let(:double) { instance_double('ParameterSchema::V1::Schema') }

    it 'call ParameterSchema::V1::Schema' do
      expect(ParameterSchema::V1::Schema).to receive(:new).with(subject.payload)

      subject.payload_data
    end

    it { expect(subject.payload_data).to be_instance_of ParameterSchema::V1::Schema }
  end

  describe '#payload_for_external_app' do
    let(:double) { instance_double('ParameterSchema::V1::ExternalApplicationAdapter') }
    let(:return_value) { { foo: :bar } }
    before do
      allow(ParameterSchema::V1::ExternalApplicationAdapter).to receive(:new).with(subject.payload_data).and_return(double)
      allow(double).to receive(:adaptee).and_return(return_value)
    end

    it 'call adaptee method for ParameterSchema::V1::ExternalApplicationAdapter instance' do
      expect(double).to receive(:adaptee)

      subject.payload_for_external_app
    end

    it { expect(subject.payload_for_external_app).to eq return_value }
  end
end
