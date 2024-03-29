require 'rails_helper'

module SdRequests
  RSpec.describe UpdatedWorker, type: :worker do
    let(:sd_request) { create(:sd_request) }
    let(:work) { create(:work, claim: sd_request) }
    let(:admin) { create(:admin) }
    let(:mailer_dbl) { double(:mailer, deliver_later: true) }

    before do
      work.users << admin
      allow(NotifyUserOnUpdateByMattermostWorker).to receive(:perform_async)
    end

    it 'send notification by email to the each user' do
      expect(UserMailer).to receive(:sd_request_updated_email).with(admin, sd_request).and_return(mailer_dbl)

      subject.perform(sd_request.id)
    end

    it 'call mailer async' do
      allow(UserMailer).to receive(:sd_request_updated_email).and_return(mailer_dbl)
      expect(mailer_dbl).to receive(:deliver_later)

      subject.perform(sd_request.id)
    end

    it 'send notification by mattermost to the each worker' do
      expect(NotifyUserOnUpdateByMattermostWorker).to receive(:perform_async).with(admin.id, sd_request.id)

      subject.perform(sd_request.id)
    end
  end
end
