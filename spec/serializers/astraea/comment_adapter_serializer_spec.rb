require 'rails_helper'

module Astraea
  RSpec.describe CommentAdapterSerializer, type: :model do
    let(:user) { create(:admin) }
    let(:comment) { create(:comment, sender: user) }
    subject { described_class.new(comment) }

    %w[user_id case_id comment].each do |attr|
      it "has #{attr} attribute" do
        expect(subject.to_json).to have_json_path(attr)
      end
    end

    it { expect(subject.as_json[:user_id]).to eq user.tn }
    it { expect(subject.as_json[:case_id]).to eq comment.claim_id }
    it { expect(subject.as_json[:comment]).to eq comment.message }
  end
end
