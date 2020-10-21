require 'rails_helper'

RSpec.describe ClaimBuilder do
  describe 'class methods' do
    subject { described_class }

    describe '.build' do
      it 'return instance of claim' do
        expect(subject.build).to be_instance_of(Claim)
      end

      specify { expect { |b| described_class.build(&b) }.to yield_control }
    end
  end

  describe 'instance methods' do
    let(:attr) { attributes_for(:claim, attrs: { foo: :bar }) }
    subject { described_class.new }

    describe '#service_id=' do
      before { subject.service_id = attr[:service_id] }

      it { expect(subject.claim.service_id).to eq attr[:service_id] }
    end

    describe '#service_name=' do
      before { subject.service_name = attr[:service_name] }

      it { expect(subject.claim.service_name).to eq attr[:service_name] }
    end

    describe '#set_service' do
      let(:service) { Service.new(id: attr[:service_id], name: attr[:service_name]) }
      before { subject.set_service(attr[:service_id], attr[:service_name]) }

      it { expect(subject.claim.service).to eq service }
    end

    describe '#app_template_id=' do
      before { subject.app_template_id = attr[:app_template_id] }

      it { expect(subject.claim.app_template_id).to eq attr[:app_template_id] }
    end

    describe '#app_template_name=' do
      before { subject.app_template_name = attr[:app_template_name] }

      it { expect(subject.claim.app_template_name).to eq attr[:app_template_name] }
    end

    describe '#set_app_template' do
      let(:app_template) { AppTemplate.new(id: attr[:app_template_id], name: attr[:app_template_name]) }
      before { subject.set_app_template(attr[:app_template_id], attr[:app_template_name]) }

      it { expect(subject.claim.app_template).to eq app_template }
    end

    describe '#status=' do
      before { subject.status = attr[:status] }

      it { expect(subject.claim.status).to eq attr[:status] }
    end

    describe '#user_credentials=' do
      before { subject.user_credentials = attr[:tn] }

      it { expect(subject.claim.tn).to eq attr[:tn] }
    end

    describe '#attrs=' do
      before { subject.attrs = attr[:attrs] }

      it { expect(subject.claim.attrs).to eq attr[:attrs].as_json }
    end

    describe '#rating=' do
      before { subject.attrs = attr[:rating] }

      it { expect(subject.claim.rating).to eq attr[:rating] }
    end

    describe '#set_runtime' do
      before { subject.set_runtime(attr[:finished_at_plan], attr[:finished_at]) }

      it { expect(subject.claim.runtime).to be_instance_of(Runtime) }
    end
  end
end
