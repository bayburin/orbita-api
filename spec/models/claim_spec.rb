require 'rails_helper'

RSpec.describe Claim, type: :model do
  it { is_expected.to have_many(:works).dependent(:destroy) }
  it { is_expected.to have_many(:comments).dependent(:destroy) }

  describe '#runtime' do
    it { expect(subject.runtime).to be_instance_of(Runtime) }
  end

  describe '#service' do
    it { expect(subject.service).to be_instance_of(Service) }
  end

  describe '#service=' do
    let(:id) { 1 }
    let(:name) { 'test name' }
    let(:service) { Service.new(id: id, name: name) }

    it 'should set service attributes to model attributes' do
      subject.service = service

      expect(subject.service_id).to eq service.id
      expect(subject.service_name).to eq service.name
    end
  end

  describe '#app_template' do
    it { expect(subject.app_template).to be_instance_of(AppTemplate) }
  end

  describe '#app_template=' do
    let(:id) { 1 }
    let(:name) { 'test name' }
    let(:app_template) { AppTemplate.new(id: id, name: name) }

    it 'should set service attributes to model attributes' do
      subject.app_template = app_template

      expect(subject.app_template_id).to eq app_template.id
      expect(subject.app_template_name).to eq app_template.name
    end
  end
end
