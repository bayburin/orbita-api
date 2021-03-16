require 'rails_helper'

module Auth
  RSpec.describe Authorize do
    subject { described_class }

    it { expect(subject.organized).to eq([ClientAccessToken, UserInfo, UpdateUser, GenerateJwt]) }
  end
end
