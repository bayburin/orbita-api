require 'rails_helper'

RSpec.describe Department, type: :model do
  it { is_expected.to have_many(:groups) }
  it { is_expected.to have_many(:users).through(:groups) }
end
