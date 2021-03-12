require 'rails_helper'

module SdRequests
  RSpec.describe WorkForm, type: :model do
    subject { described_class.new(Work.new) }
    let(:params) { { work: attributes_for(:work) } }

    it { is_expected.to validate_presence_of(:group_id) }
  end
end
