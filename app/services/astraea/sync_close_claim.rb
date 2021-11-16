module Astraea
  # Синхронизирует данные с системой Astraea (закрывает заявку).
  class SyncCloseClaim
    include Interactor

    delegate :event, :need_update_astraea, to: :context

    def call
      return unless need_update_astraea

      CloseCaseWorker.perform_async(event.claim.integration_id_for('Astraea'), event.user.tn)
    end
  end
end
