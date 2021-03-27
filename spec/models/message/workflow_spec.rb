require 'rails_helper'

RSpec.describe Workflow, type: :model do
  it { is_expected.to belong_to(:work) }
end
