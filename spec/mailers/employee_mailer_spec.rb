require 'rails_helper'

RSpec.describe EmployeeMailer, type: :mailer do
  let(:recipient) { create(:admin) }

  describe '#sd_request_created_email' do
    let(:sd_request) { create(:sd_request) }
    let(:mail) { described_class.sd_request_created_email(recipient.fio, recipient.email, sd_request) }
    let(:sender) { ENV['ACTION_MAILER_USERNAME'] }

    it 'create job' do
      expect { mail.deliver_later }.to have_enqueued_job.on_queue('mailers')
    end

    it 'render the subject' do
      expect(mail.subject).to eq("Портал \"Орбита\": создана новая заявка №#{sd_request.id}")
    end

    it 'render the recipient email' do
      expect(mail.to).to eq([recipient.email])
    end

    it 'render the sender email' do
      expect(mail.from).to eq([sender])
    end
  end
end
