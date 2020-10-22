module Events
  # Класс-обработчик события выполнения некоторого действия во внешней системе (аналог workflow в текущей системе).
  class WorkflowEvent
    include Interactor

    delegate :event, :work, :workflow, to: :context

    def call
      # Проверка существования заявки и пользователя
      claim = Claim.find(event.claim_id)
      user = User.find_by(id_tn: event.id_tn)
      context.fail!(error: 'Пользователь не найден') unless user

      Work.transaction do
        # Проверка наличия работы и ее создания
        context.work = claim.works.where(group_id: user.group_id).first_or_create do |w|
          w.group_id = user.group_id
        end
        # Подключение полученного пользователя к работе
        # TODO: На этом этапе должно логироваться подключение нового пользователя, если его раньше не было в работе по заявке
        work.users << user

        # Создание записи workflow
        context.workflow = work.workflows.build(
          message: event.payload['message'],
          sender: user,
          claim: claim
        )

        if workflow.save
          context.message = 'successfully created'
        else
          context.fail!(error: workflow.errors.full_messages)
        end
      end
    end
  end
end
