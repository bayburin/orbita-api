require 'rails_helper'

RSpec.describe Parameter, type: :model do
  it { is_expected.to belong_to(:claim) }
end
