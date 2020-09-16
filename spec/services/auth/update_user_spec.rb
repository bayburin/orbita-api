require 'rails_helper'

module Auth
  RSpec.describe UpdateUser do
    let!(:user) { create(:admin) }
    let(:user_params) do
      {
        id_tn: user.id_tn,
        tn: user.tn + 1,
        fio: user.fio + 'new',
        tel: user.work_tel + 'new',
        email: user.email + 'new'
      }
    end
    let(:params) { { user_info: user.as_json } }
    subject(:context) { described_class.call(params) }

    describe '.call' do
      it 'finished with success' do
        expect(context).to be_a_success
      end

      context 'when user not found' do
        before { allow(User).to receive(:find_by).and_return(nil) }

        it 'finished with fail' do
          expect(context).to be_a_failure
        end

        it 'set message to context' do
          expect(context.message).to eq 'Доступ запрещен'
        end
      end

      it 'update user data' do
        context.user.tn = user_params[:tn]
        context.user.fio = user_params[:fio]
        context.user.work_tel = user_params[:tel]
        context.user.email = user_params[:email]
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
