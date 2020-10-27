module Events
  module Requirements
    extend ActiveSupport::Concern

    included do
      around do |interactor|
        context.fail!(error: 'Заявка не найдена') unless context.event.claim
        context.fail!(error: 'Пользователь не найден') unless context.event.user

        interactor.call
      end
    end
  end
end
