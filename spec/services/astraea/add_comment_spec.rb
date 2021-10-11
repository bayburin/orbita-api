require 'rails_helper'

module Astraea
  RSpec.describe AddComment do
    let(:user) { create(:admin) }
    let(:comment) { create(:comment) }
    let(:json_form) { comment.as_json }
    subject(:context) { described_class.call(comment: comment) }
    let(:response) { double(:astraea_response, success?: true, body: {}) }
    before do
      allow(CommentAdapterSerializer).to receive(:new).with(comment).and_return(json_form)
      allow(Api).to receive(:save_sd_request).and_return(response)
    end

    describe '.call' do
      it { expect(context).to be_a_success }

      it 'call CommentAdapterSerializer serializer' do
        expect(CommentAdapterSerializer).to receive(:new).with(comment)

        context
      end

      it 'call Api.save_sd_request method' do
        expect(Api).to receive(:save_sd_request).with(json_form)

        context
      end

      context 'when Api raise connection error' do
        before { allow(Api).to receive(:save_sd_request).and_raise(Faraday::ConnectionFailed, 'Failed to open TCP connection') }

        it { expect(context).to be_a_success }
      end
    end
  end
end
