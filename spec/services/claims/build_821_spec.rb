require 'rails_helper'

module Claims
  RSpec.describe Build821 do
    subject(:context) { described_class.call }

    describe '.call' do
      it { expect(context.claim).to be_instance_of Claim }
      it { expect(context.claim.service_name).to eq 'Отдел 821' }
      it { expect(context.claim.app_template_name).to eq 'Заявка на размножение КД' }
    end
  end
end
