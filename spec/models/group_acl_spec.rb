require 'rails_helper'

RSpec.describe GroupAcl, type: :model do
  it { is_expected.to belong_to(:role) }
  it { is_expected.to belong_to(:group) }
  it { is_expected.to belong_to(:acl) }
end
