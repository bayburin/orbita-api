require 'rails_helper'

RSpec.describe Case, type: :model do
  it { is_expected.to be_kind_of Claim }
end
