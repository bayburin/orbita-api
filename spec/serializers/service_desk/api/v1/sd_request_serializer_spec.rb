require 'rails_helper'

module ServiceDesk
  module Api
    module V1
      RSpec.describe SdRequestSerializer, type: :model do
        let!(:claim) { create(:claim) }
        let!(:work) { create(:work, claim: claim) }
        let!(:message) { create(:to_user_accept, work: work) }
        let!(:workflow) { create(:workflow, work: work) }
        let!(:public_attachment) { create(:attachment, is_public: true, claim: claim) }
        let!(:private_attachment) { create(:attachment, claim: claim) }
        subject { described_class.new(claim).to_json }

        %w[id service_id ticket_identity service_name ticket_name description status rating runtime attachments user_messages].each do |attr|
          it "has #{attr} attribute" do
            expect(subject).to have_json_path(attr)
          end
        end

        it { expect(parse_json(subject)['attachments'].length).to eq 1 }
        it { expect(parse_json(subject)['attachments'][0]['id']).to eq public_attachment.id }

        it { expect(parse_json(subject)['user_messages'].length).to eq 1 }
        it { expect(parse_json(subject)['user_messages'][0]['id']).to eq message.id }
      end
    end
  end
end
