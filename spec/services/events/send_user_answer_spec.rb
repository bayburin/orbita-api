require 'rails_helper'

module Events
  RSpec.describe SendUserAnswer do
    let(:sd_request) { create(:sd_request) }
    let(:work) { create(:work, claim: claim) }
    let(:to_user_accept) { create(:to_user_accept) }
    let(:response_dbl) { double('response', success?: true) }
    subject(:context) { described_class.call(from_user_accept: to_user_accept) }
    before { allow(Api).to receive(:send_user_answer).and_return(response_dbl) }

    describe '.call' do
      it { expect(context).to be_a_success }

      it 'call Api.send_user_answer method' do
        expect(Api).to receive(:send_user_answer).with(to_user_accept.accept_endpoint, to_user_accept.accept_value, to_user_accept.accept_comment)

        context
      end
    end
  end
end
