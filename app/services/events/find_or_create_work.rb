module Events
  # Ищет работу по текущей заявке для указанной группы. Если находит, добавляет исполнителя в работу. Если нет, сначала создает работу,
  # а потом добавляет в нее исполнителя.
  class FindOrCreateWork
    include Interactor

    delegate :work, :user, :claim, to: :context

    def call
      context.work = claim.works.where(group_id: user.group_id).first_or_initialize do |w|
        w.group_id = user.group_id
      end
      work.users << user

      context.fail!(error: work.errors.full_messages) unless context.work.save
    end
  end
end
