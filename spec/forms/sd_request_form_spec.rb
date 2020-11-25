require 'rails_helper'

RSpec.describe SdRequestForm, type: :model do
  subject { described_class.new(SdRequest.new) }
  let(:params) { { sd_request: attributes_for(:sd_request) } }
end
