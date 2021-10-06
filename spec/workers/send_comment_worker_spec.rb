require 'rails_helper'

RSpec.describe SendCommentWorker, type: :worker do
  let(:sd_request) { create(:sd_request) }
  let(:comment) { create(:comment, claim: sd_request) }
  let(:admin) { create(:admin) }

  it 'broadcast created comment' do
    expect(CommentsChannel).to receive(:broadcast_to).with(sd_request, any_args)

    subject.perform(sd_request.id, comment.id)
  end
end
