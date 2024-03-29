require 'rails_helper'

module SdRequests
  RSpec.describe BuildFromEvent do
    let(:sd_request) { build(:sd_request) }
    let(:sd_request_dbl) { double(:sd_request, build_works_by_responsible_users: true) }
    let(:ticket) { build(:sd_ticket) }
    let(:id_tn) { 1234 }
    let(:form_dbl) { instance_double('SdRequestForm') }
    let(:application_id) { 123 }
    let(:token_dbl) { double(:token, application: double(:application, id: application_id)) }
    subject(:context) { described_class.call(ticket: ticket, params: { id_tn: id_tn }, doorkeeper_token: token_dbl) }
    before do
      allow(SdRequestBuilder).to receive(:build).and_yield(sd_request_dbl).and_return(sd_request)
      allow(sd_request_dbl).to receive(:ticket=)
      allow(sd_request_dbl).to receive(:application_id=)
      allow(sd_request_dbl).to receive(:status=)
      allow(SdRequestForm).to receive(:new).and_return(form_dbl)
    end

    describe '.call' do
      it { expect(context).to be_a_success }
      it { expect(context.sd_request).to be_instance_of(SdRequest) }

      it 'set ticket' do
        expect(sd_request_dbl).to receive(:ticket=).with(ticket)

        context
      end

      it 'call build_works_by_responsible_users method' do
        expect(sd_request_dbl).to receive(:build_works_by_responsible_users).with(ticket.responsible_users)

        context
      end

      it 'set application_id' do
        expect(sd_request_dbl).to receive(:application_id=).with(application_id)

        context
      end

      it 'set at_work status' do
        expect(sd_request_dbl).to receive(:status=).with(:at_work)

        context
      end

      it { expect(context.params[:source_snapshot][:id_tn]).to eq id_tn }

      it 'create form instance' do
        expect(CreateForm).to receive(:new).with(sd_request)

        context
      end

      it { expect(context.form).to be form_dbl }
    end
  end
end
