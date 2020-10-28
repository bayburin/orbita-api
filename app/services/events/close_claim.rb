module Events
  # Закрывает заявку.
  class CloseClaim
    include Interactor

    delegate :event, to: :context

    def call
      if event.claim.update(finished_at: Time.zone.now)
        context.claim = event.claim
      else
        context.fail!(error: event.claim.errors.full_messages)
      end
    end
  end
end
