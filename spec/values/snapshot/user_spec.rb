require 'rails_helper'

module Snapshot
  RSpec.describe User do
    let(:attrs) { attributes_for(:source_snapshot_user, fio: 'ОДИНОКИЙ-УТЕС ТАТЬЯНА Д МИХАЙЛОВНА') }
    subject { described_class.new(attrs) }

    it { expect(subject.fio).to eq 'Одинокий-Утес Татьяна Д Михайловна' }
    it { expect(subject.phone).to eq attrs[:user_attrs][:phone] }
    it { expect(subject.email).to eq attrs[:user_attrs][:email] }
  end
end
