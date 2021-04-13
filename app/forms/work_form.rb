# Описывает форму, которая создает работу по заявке.
class WorkForm < Reform::Form
  property :id
  property :claim_id
  property :group_id
  collection :workers, form: WorkerForm, populator: :populate_workers!
  collection :workflows, form: MessageForm, populator: :populate_workflows!

  attr_accessor :current_user, :history_store, :work_obj

  validation do
    option :form
    config.messages.backend = :i18n

    params do
      required(:group_id).filled(:int?)
      # optional(:workflows)
    end

    rule(:group_id) do
      key.failure(:already_exist) if Work.where.not(id: form.model.id).where(group_id: value, claim_id: form.claim_id).exists?
    end
    # rule(:workflows).each do |index:|
    #   next if value[:id]

    #   key([:workflows, :sender_id, index]).failure(:invalid_group) if form.current_user.group_id != form.group_id
    #   # base.failure('test message') if form.current_user.group_id != form.group_id
    # end
  end

  # Обработка ответственных
  def populate_workers!(fragment:, **)
    item = workers.find { |worker| worker.user_id == fragment[:user_id].to_i }

    if fragment[:_destroy].to_s == 'true'
      history_store.add_to_combine(:del_workers, fragment[:user_id]) if item
      workers.delete(item)
      return skip!
    end

    if item
      item
    else
      history_store.add_to_combine(:add_workers, fragment[:user_id]) unless fragment[:user_id] == current_user.id
      workers.append(Worker.new)
    end
  end

  # Обработка списка сообщений рабочего процесса
  def populate_workflows!(fragment:, **)
    return skip! if fragment[:id]

    history_store.add(Histories::WorkflowType.new(workflow: fragment[:message]).build)
    workflows.append(Workflow.new(sender: current_user))
  end
end
