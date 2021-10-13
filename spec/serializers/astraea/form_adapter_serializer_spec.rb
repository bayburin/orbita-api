require 'rails_helper'

module Astraea
  RSpec.describe FormAdapterSerializer, type: :model do
    let(:form) { SdRequests::CreateForm.new(create(:sd_request)) }
    let(:user) { create(:admin) }
    let(:adapter) { FormAdapter.new(form, user, 'new') }
    subject { described_class.new(adapter).to_json }

    %w[user_id case_id phone host_id barcode desc analysis rem_date rem_hour rem_min severity users].each do |attr|
      it "has #{attr} attribute" do
        expect(subject).to have_json_path(attr)
      end
    end
  end
end
