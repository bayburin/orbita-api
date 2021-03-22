require 'rails_helper'

module Snapshot
  RSpec.describe User do
    let(:attrs) do
      {
        id_tn: 12_345,
        fio: 'ОДИНОКИЙ-УТЕС ТАТЬЯНА Д МИХАЙЛОВНА'
      }
    end
    subject { described_class.new(attrs) }

    it { expect(subject.fio).to eq 'Одинокий-Утес Татьяна Д Михайловна' }
  end
end
