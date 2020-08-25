require 'rails_helper'

RSpec.describe History, type: :model do
  it { is_expected.to belong_to(:work) }
  it { is_expected.to belong_to(:user) }
end
