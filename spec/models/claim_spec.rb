require 'rails_helper'

RSpec.describe Claim, type: :model do
  it { is_expected.to have_many(:works).dependent(:destroy) }
end
