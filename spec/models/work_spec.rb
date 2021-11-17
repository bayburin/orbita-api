require 'rails_helper'

RSpec.describe Work, type: :model do
  it { is_expected.to have_many(:workers).dependent(:destroy) }
  it { is_expected.to have_many(:users).through(:workers) }
  it { is_expected.to have_many(:histories).dependent(:destroy) }
  it { is_expected.to have_many(:workflows).dependent(:destroy) }
  it { is_expected.to have_many(:messages).dependent(:destroy) }
  it { is_expected.to have_many(:to_user_messages).dependent(:destroy) }
  it { is_expected.to have_many(:to_user_accepts).dependent(:destroy) }
  it { is_expected.to belong_to(:claim) }
  it { is_expected.to belong_to(:group) }
end
