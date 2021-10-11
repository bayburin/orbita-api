require 'rails_helper'

module SdRequests
  RSpec.describe BroadcastCreatedRecordWorker, type: :worker do
    let(:sd_request) { create(:sd_request) }
    before { allow(ActionCable.server).to receive(:broadcast) }


    it 'broadcast updated sd_request' do
      expect(ActionCable.server).to receive(:broadcast).with('sd_requests::create', nil)

      subject.perform(sd_request.id)
    end
  end
end
