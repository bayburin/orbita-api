require 'rails_helper'

RSpec.describe WorkForm, type: :model do
  let!(:work) { create(:work) }
  let(:user) { create(:admin) }
  let(:history_store_dbl) { instance_double('Histories::Storage', add: true) }
  let(:params) { { work: work.as_json } }
  subject do
    described_class.new(work).tap do |form|
      form.history_store = history_store_dbl
      form.current_user = user
    end
  end

  describe 'validations' do
    context 'when group_id is empty' do
      before { subject.validate(group_id: '') }

      it { expect(subject.errors.messages).to include(:group_id) }
      it { expect(subject.errors.messages[:group_id]).to include('не может быть пустым') }
    end

    context 'when group_id is not a number' do
      before { subject.validate(group_id: 'test') }

      it { expect(subject.errors.messages).to include(:group_id) }
      it { expect(subject.errors.messages[:group_id]).to include('должен быть числом') }
    end

    context 'when its a new object, but such group_id already exist' do
      subject do
        described_class.new(Work.new).tap do |form|
          form.history_store = history_store_dbl
          form.current_user = user
        end
      end
      before { subject.validate(id: work.id + 1, claim_id: work.claim_id, group_id: work.group_id) }

      it { expect(subject.errors.messages).to include(:group_id) }
    end
  end

  describe '#populate_workers!' do
    let(:new_user) { create(:manager) }
    let(:del_user) { create(:manager) }
    let!(:worker) { create(:worker, work: work, user: del_user) }
    let(:params) do
      attributes_for(:work).merge(
        group_id: new_user.group_id,
        workers: [
          { user_id: user.id },
          { user_id: new_user.id },
          { user_id: del_user.id, _destroy: true }
        ]
      )
    end
    before do
      subject.work_obj = { add_workers: [], del_workers: [] }
      subject.validate(params)
    end

    it { expect(subject.instance_variable_get(:@work_obj)[:add_workers]).to include(new_user.id) }
    it { expect(subject.instance_variable_get(:@work_obj)[:del_workers]).to include(del_user.id) }
    it { expect(subject.instance_variable_get(:@work_obj)[:add_workers]).not_to include(subject.current_user.id) }
  end

  describe '#popualate_workflows!' do
    let!(:workflow) { create(:workflow, message: old_workflow, work: work) }
    let(:old_workflow) { 'old message' }
    let(:new_workflow) { 'new message' }
    let(:history_dbl) { double(:history) }
    let(:workflow_type_dbl) { instance_double('Histories::WorkflowType', build: history_dbl) }
    let(:params) do
      attributes_for(:work).merge(
        group_id: user.group_id,
        workflows: [
          { id: workflow.id, message: new_workflow },
          { message: new_workflow }
        ]
      )
    end
    before { allow(Histories::WorkflowType).to receive(:new).with(workflow: new_workflow).and_return(workflow_type_dbl) }

    it 'add history with new workflow' do
      expect(history_store_dbl).to receive(:add).with(history_dbl)

      subject.validate(params)
    end

    it 'does not update workflow which has id' do
      subject.validate(params)
      subject.save

      expect(workflow.reload.message).to eq old_workflow
    end

    it 'does not add history with workflow which has id' do
      expect(history_store_dbl).to receive(:add).exactly(1).times

      subject.validate(params)
    end
  end
end
