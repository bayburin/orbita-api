module Events
  # Ищет работу по текущей заявке для указанной группы. Если находит, добавляет исполнителя в работу. Если нет, сначала создает работу,
  # а потом добавляет в нее исполнителя.
  class FindOrCreateWork
    include Interactor

    delegate :event, to: :context

    def call
      work = event.claim.find_or_initialize_work_by_user(event.user)
      unless work.workers.exists?(user_id: event.user.id)
        context.skip_history = false
        work.users << event.user
      end

      if work.save
        event.work = work
      else
        context.fail!(error: work.errors.full_messages)
      end
    end
  end
end
