require 'rails_helper'

RSpec.describe UserAcl, type: :model do
  it { is_expected.to belong_to(:user) }
  it { is_expected.to belong_to(:acl) }
end
