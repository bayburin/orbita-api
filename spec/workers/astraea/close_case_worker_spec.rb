require 'rails_helper'

module Astraea
  RSpec.describe CloseCaseWorker, type: :worker do
    let(:case_id) { 123 }
    let(:admin) { create(:admin) }
    let(:response_dbl) { double('response', success?: true, body: { message: 'ok' }.as_json) }
    let(:body) do
      {
        close: 1,
        case_id: case_id,
        user_id: admin.tn
      }
    end
    before { allow(Api).to receive(:close_case).with(body).and_return(response_dbl) }

    it 'call Astraea api to close case' do
      expect(Api).to receive(:close_case).with(body)

      subject.perform(case_id, admin.tn)
    end

    context 'when Api raise error' do
      before { allow(Api).to receive(:close_case).and_raise(Faraday::ConnectionFailed, 'error') }

      it { expect(subject.perform(case_id, admin.tn)).to be_nil }
    end
  end
end
