module Events
  # Добавляет исполнителей к заявке на основании полученного события Event.
  class CreateWorkers
    include Interactor

    delegate :event, :history_store, to: :context

    def call
      user_groups = User.where(tn: event.payload['tns']).group_by(&:group_id)

      workers = []
      user_groups.each do |group_id, users|
        work = event.claim.find_or_initialize_work_by_user(users.first)
        users.each do |user|
          next if work.workers.exists?(user_id: user.id)

          worker = work.workers.build(user_id: user.id)
          history_store.add_to_combine(:add_workers, user.id)
          workers << worker
        end
      end

      if workers.empty?
        nil
      elsif workers.all?(&:save)
        history_store.save!
        SdRequests::BroadcastUpdatedRecordWorker.perform_async(event.claim.id)
      else
        context.fail!(error: workers.map { |worker| "#{worker.user.tn}: #{worker.errors.full_messages}" })
      end
    end
  end
end
