require 'rails_helper'

RSpec.describe SdRequests::NotifyUserOnCreateByMattermostWorker, type: :worker do
  let(:user) { create(:admin) }
  let(:sd_request) { create(:sd_request) }
  let(:response_dbl) { double(:response, status: 200, body: {}) }
  let(:file_content) { 'test content' }
  before do
    allow(Mattermost::Api).to receive(:notify).and_return(response_dbl)
    allow_any_instance_of(File).to receive(:read).and_return(file_content)
  end

  it 'call Mattermost::Api.notify method' do
    expect(Mattermost::Api).to receive(:notify).with("@#{user.login}", file_content)

    subject.perform(user.id, sd_request.id)
  end

  it 'raise error if Mattermost::Api.notify finished with 500 status' do
    allow(response_dbl).to receive(:status).and_return(500)

    expect { subject.perform(user.id, sd_request.id) }.to raise_error(StandardError)
  end
end
