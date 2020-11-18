require 'rails_helper'

RSpec.describe ApplicationForm, type: :model do
  subject { described_class.new(Application.new) }
  let(:params) { { application: attributes_for(:application) } }
end
