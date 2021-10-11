require 'rails_helper'

RSpec.describe Message, type: :model do
  it { is_expected.to belong_to(:sender).with_foreign_key(:sender_id).class_name('User') }
end
