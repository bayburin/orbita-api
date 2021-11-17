require 'rails_helper'

module ServiceDesk
  module Api
    module V1
      RSpec.describe UserMessageSerializer, type: :model do
        let(:message) { create(:to_user_accept) }
        subject { described_class.new(message).to_json }

        %w[id claim_id type message accept_value accept_comment created_at].each do |attr|
          it "has #{attr} attribute" do
            expect(subject).to have_json_path(attr)
          end
        end
      end
    end
  end
end
