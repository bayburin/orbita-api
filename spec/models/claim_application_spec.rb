require 'rails_helper'

RSpec.describe ClaimApplication, type: :model do
  it { is_expected.to belong_to(:application).class_name('Doorkeeper::Application') }
  it { is_expected.to belong_to(:claim) }
end
