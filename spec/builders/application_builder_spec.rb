require 'rails_helper'

RSpec.describe ApplicationBuilder do
  include_examples 'base builder', Application

  describe 'instance methods' do
    let(:attr) { attributes_for(:application, attrs: { foo: :bar }) }
    subject { described_class.new }

    describe '#service_id=' do
      before { subject.service_id = attr[:service_id] }

      it { expect(subject.model.service_id).to eq attr[:service_id] }
    end

    describe '#service_name=' do
      before { subject.service_name = attr[:service_name] }

      it { expect(subject.model.service_name).to eq attr[:service_name] }
    end

    describe '#set_service' do
      let(:service) { Service.new(id: attr[:service_id], name: attr[:service_name]) }
      before { subject.set_service(attr[:service_id], attr[:service_name]) }

      it { expect(subject.model.service).to eq service }
    end

    describe '#app_template_id=' do
      before { subject.app_template_id = attr[:app_template_id] }

      it { expect(subject.model.app_template_id).to eq attr[:app_template_id] }
    end

    describe '#app_template_name=' do
      before { subject.app_template_name = attr[:app_template_name] }

      it { expect(subject.model.app_template_name).to eq attr[:app_template_name] }
    end

    describe '#set_app_template' do
      let(:app_template) { AppTemplate.new(id: attr[:app_template_id], name: attr[:app_template_name]) }
      before { subject.set_app_template(attr[:app_template_id], attr[:app_template_name]) }

      it { expect(subject.model.app_template).to eq app_template }
    end

    describe '#status=' do
      before { subject.status = attr[:status] }

      it { expect(subject.model.status).to eq attr[:status] }
    end

    # describe '#user_credentials=' do
    #   let(:user_info) { { lastName: 'last', firstName: 'first', middleName: 'middle', employeePositions: [{ personnelNo: 1, departmentForAccounting: 700 }] }.as_json }
    #   before do
    #     allow_any_instance_of(Employees::Employee).to receive(:load).with(attr[:id_tn]).and_return(user_info)
    #     subject.user_credentials = attr[:id_tn]
    #   end

    #   it { expect(subject.model.id_tn).to eq attr[:id_tn] }
    #   it { expect(subject.model.tn).to eq user_info['employeePositions'][0]['personnelNo'] }
    #   it { expect(subject.model.fio).to eq "#{user_info['lastName']} #{user_info['firstName']} #{user_info['middleName']}" }
    #   it { expect(subject.model.dept).to eq user_info['employeePositions'][0]['departmentForAccounting'] }
    # end

    describe '#attrs=' do
      before { subject.attrs = attr[:attrs] }

      it { expect(subject.model.attrs).to eq attr[:attrs].as_json }
    end

    describe '#rating=' do
      before { subject.attrs = attr[:rating] }

      it { expect(subject.model.rating).to eq attr[:rating] }
    end

    describe '#set_runtime' do
      before { subject.set_runtime(attr[:finished_at_plan], attr[:finished_at]) }

      it { expect(subject.model.runtime).to be_instance_of(Runtime) }
    end
  end
end
