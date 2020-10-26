module Events
  module Requirements
    extend ActiveSupport::Concern

    included do
      around do |interactor|
        context.claim = Claim.find_by(id: context.event.claim_id)
        context.fail!(error: 'Заявка не найдена') unless context.claim

        context.user = User.find_by(id_tn: context.event.id_tn)
        context.fail!(error: 'Пользователь не найден') unless context.user

        interactor.call
      end
    end
  end
end
