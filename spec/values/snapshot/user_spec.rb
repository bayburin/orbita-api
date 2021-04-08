require 'rails_helper'

module Snapshot
  RSpec.describe User do
    let(:attrs) { attributes_for(:source_snapshot_user, fio: 'ОДИНОКИЙ-УТЕС ТАТЬЯНА Д МИХАЙЛОВНА') }
    subject { described_class.new(attrs) }

    it { expect(subject.fio).to eq 'Одинокий-Утес Татьяна Д Михайловна' }
  end
end
