require 'rails_helper'

RSpec.describe WorkForm, type: :model do
  subject { described_class.new(Work.new) }
  let(:params) { { work: attributes_for(:work) } }
end
