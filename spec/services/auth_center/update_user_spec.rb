require 'rails_helper'

module AuthCenter
  RSpec.describe UpdateUser do
    let!(:user) { create(:admin, email: 'test') }
    let!(:user_params) do
      {
        id_tn: user.id_tn,
        tn: user.tn + 1,
        fio: user.fio + 'new fio',
        tel: user.work_tel + 'new tel',
        email: user.email + 'new'
      }
    end
    let(:auth_data) { build(:auth_center_token) }
    let(:params) { { user_info: user_params.as_json, auth_data: auth_data } }
    subject(:context) { described_class.call(params) }

    describe '.call' do
      it { expect(context).to be_a_success }

      context 'when user not found' do
        before { allow(User).to receive(:find_by).and_return(nil) }

        it { expect(context).to be_a_failure }
        it { expect(context.message).to eq 'Доступ запрещен' }
      end

      it { expect(context.user.tn).to eq user_params[:tn] }
      it { expect(context.user.fio).to eq user_params[:fio] }
      it { expect(context.user.work_tel).to eq user_params[:tel] }
      it { expect(context.user.email).to eq "#{user_params[:email]}@iss-reshetnev.ru" }

      context 'when email is nil' do
        before { user_params['email'] = nil }

        it { expect(context.user.email).to be_nil }
      end

      context 'when email is empty string' do
        before { user_params['email'] = '' }

        it { expect(context.user.email).to be_nil }
      end

      context 'when user was not updated' do
        before { allow_any_instance_of(User).to receive(:update).and_return(false) }

        it 'finished with fail' do
          expect(context).to be_a_failure
        end
      end
    end
  end
end
