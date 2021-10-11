require 'rails_helper'

module Users
  RSpec.describe Authorize do
    subject { described_class }

    it { expect(subject.organized).to eq([AuthCenter::ClientToken, AuthCenter::UserInfo, AuthCenter::UpdateUser, AuthCenter::GenerateJwt]) }
  end
end
