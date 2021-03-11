require 'rails_helper'

RSpec.describe UserMailer, type: :mailer do
  let(:recipient) { create(:admin) }

  shared_examples_for 'a mailer' do
    let(:sender) { ENV['ACTION_MAILER_USERNAME'] }

    it 'render the recipient email' do
      expect(mail.to).to eq([recipient.email])
    end

    it 'render the sender email' do
      expect(mail.from).to eq([sender])
    end
  end

  describe '#question_created_email' do
    let(:sd_request) { create(:sd_request) }
    let(:mail) { described_class.question_created_email(recipient, sd_request) }

    it 'render the subject' do
      expect(mail.subject).to eq("Портал \"Орбита\": создана новая заявка №#{sd_request.id}")
    end

    it_behaves_like 'a mailer'
  end
end