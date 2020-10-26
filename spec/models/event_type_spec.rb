require 'rails_helper'

RSpec.describe EventType, type: :model do
  it { is_expected.to have_many(:histories).dependent(:nullify) }
end
