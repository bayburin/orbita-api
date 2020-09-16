require 'rails_helper'

module Auth
  RSpec.describe Authorize do
    subject { described_class }

    it { expect(subject.organized).to eq([AccessToken, UserInfo, UpdateUser, GenerateJwt]) }
  end
end
