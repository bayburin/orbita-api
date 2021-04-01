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

    params { required(:group_id).filled(:int?) }

    rule(:group_id) do
      key.failure(:already_exist) if Work.where(group_id: value, claim_id: form.claim_id).exists?
    end
  end

  # Обработка ответственных
  def populate_workers!(fragment:, **)
    item = workers.find { |worker| worker.user_id == fragment[:user_id].to_i }

    if fragment[:_destroy].to_s == 'true'
      work_obj[:del_workers] << fragment[:user_id] if item
      workers.delete(item)
      return skip!
    end

    if item
      item
    else
      work_obj[:add_workers] << fragment[:user_id]
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
