require 'rails_helper'

module Employees
  RSpec.describe Search do
    let(:filters) { { foo: :bar } }
    let(:adapter_dbl) { instance_double(EmployeeFilterAdapter, convert: true) }
    let(:api_response) { { data: [{ fio: 'first' }, { fio: 'second' }] } }
    let(:converted_filters) { 'converted-string' }
    subject(:context) { described_class.call(filters: filters) }
    before do
      allow(EmployeeFilterAdapter).to receive(:new).with(filters).and_return(adapter_dbl)
      allow(adapter_dbl).to receive(:convert).and_return(converted_filters)
      allow_any_instance_of(Employees::Loader).to receive(:load).and_return(api_response.as_json)
    end

    describe '.call' do
      it { expect(context).to be_a_success }
      it { expect(context.employees).to eq api_response[:data].as_json }

      it 'should call convert method' do
        expect(adapter_dbl).to receive(:convert)

        context
      end

      it 'call Employees::Loader.load method' do
        expect_any_instance_of(Employees::Loader).to receive(:load).with(converted_filters)

        context
      end

      context 'when filters is empty' do
        subject(:context) { described_class.call(filters: {}) }

        it { expect(context).to be_a_success }
        it { expect(context.employees).to eq [] }
      end

      context 'when Employees::Loader does not return data' do
        before { allow_any_instance_of(Employees::Loader).to receive(:load).and_return(nil) }

        it { expect(context).to be_a_success }
        it { expect(context.employees).to eq [] }
      end
    end
  end
end
