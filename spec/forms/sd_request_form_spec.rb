require 'rails_helper'

RSpec.describe SdRequestForm, type: :model do
  subject { described_class.new(SdRequest.new) }
  let(:params) { { sd_request: attributes_for(:sd_request) } }

  it { is_expected.to validate_presence_of(:service_name) }
  it { is_expected.to validate_presence_of(:attrs) }

  describe '#populate_source_snapshot!' do
    let(:ss_params) { { id_tn: 123 } }
    let(:params) { attributes_for(:sd_request, source_snapshot: ss_params) }
    let(:source_snapshot_dbl) { double(:source_snapshot) }
    before do
      allow_any_instance_of(SourceSnapshotBuilder).to receive(:user_credentials=)
    end

    it 'call SourceSnapshotBuilder' do
      expect(SourceSnapshotBuilder).to receive(:build).and_call_original

      subject.validate(params)
    end

    it 'set user_credentials' do
      expect_any_instance_of(SourceSnapshotBuilder).to receive(:user_credentials=).with(ss_params[:id_tn])

      subject.validate(params)
    end
  end
end
