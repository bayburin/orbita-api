require 'rails_helper'

RSpec.describe SdRequests::NotifyEmployeeOnCreateByEmailWorker, type: :worker do
  let(:sd_request) { create(:sd_request) }
  let(:mailer_dbl) { double(:mailer, deliver_now: true) }
  before { allow(EmployeeMailer).to receive(:sd_request_created_email).and_return(mailer_dbl) }

  it 'call EmployeeMailer.sd_request_created_email mailer' do
    expect(EmployeeMailer).to receive(:sd_request_created_email).with(sd_request.source_snapshot.fio, sd_request.source_snapshot.user_attrs['email'], sd_request)

    subject.perform(sd_request.id)
  end

  it 'call mailer sync' do
    expect(mailer_dbl).to receive(:deliver_now)

    subject.perform(sd_request.id)
  end

  context 'when source_snapshot does not have email' do
    let(:email) { 'my-custom-email' }
    let(:employee) { { employeeContact: { email: [email] } }.as_json }

    before do
      allow_any_instance_of(SourceSnapshot).to receive(:user_attrs).and_return({})
      allow_any_instance_of(Employees::Loader).to receive(:load).and_return(employee)
    end

    it 'load email with Employees::Loader service' do
      expect(EmployeeMailer).to receive(:sd_request_created_email).with(sd_request.source_snapshot.fio, email, sd_request)

      subject.perform(sd_request.id)
    end

    context 'when user Employees::Loader service is not responding' do
      before { allow_any_instance_of(Employees::Loader).to receive(:load).and_return(nil) }

      it { expect { subject.perform(sd_request.id) }.to raise_error(RuntimeError) }
    end

    context 'and when user does not have email' do
      let(:employee) { { employeeContact: { email: [] } }.as_json }

      it { expect(subject.perform(sd_request.id)).to be_nil }
    end
  end
end
