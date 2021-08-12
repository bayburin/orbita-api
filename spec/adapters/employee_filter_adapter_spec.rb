require 'rails_helper'

RSpec.describe EmployeeFilterAdapter do
  let(:params) do
    {
      tn: {
        value: '12345',
        matchMode: 'equals'
      },
      fio: {
        value: 'fake-fio',
        matchMode: 'contains'
      }
    }.as_json
  end
  let(:result) { "tn=='12345';fio=='*fake-fio*'" }
  subject { described_class.new(params) }

  it { expect(subject.convert).to eq result }

  context 'when value is empty' do
    before { params['tn']['value'] = '' }

    it { expect(subject.convert).to eq "fio=='*fake-fio*'" }
  end
end
