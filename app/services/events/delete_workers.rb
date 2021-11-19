module Events
  # Удаляет исполнителей из заявке на основании полученного события Event.
  class DeleteWorkers
    include Interactor

    delegate :event, :history_store, to: :context

    def call
      users = User.where(tn: event.payload['tns'])
      workers = Worker.joins(:work).where(works: { claim: event.claim }, user: users)
      workers.map { |worker| history_store.add_to_combine(:del_workers, worker.user_id) }

      if workers.any?
        workers.delete_all
        history_store.save!
        SdRequests::BroadcastUpdatedRecordWorker.perform_async(event.claim.id)
      end
    end
  end
end
