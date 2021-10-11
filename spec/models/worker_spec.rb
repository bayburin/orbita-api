require 'rails_helper'

RSpec.describe Worker, type: :model do
  it { is_expected.to belong_to(:work) }
  it { is_expected.to belong_to(:user) }
end
