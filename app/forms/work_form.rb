# Описывает форму, которая создает работу по заявке.
class WorkForm < Reform::Form
  property :id
  property :claim_id
  property :group_id
  collection :workers, form: WorkerForm, populator: :populate_workers!
  collection :workflows, form: MessageForm, populator: :populate_workflows!

  attr_accessor :current_user

  validation do
    option :form
    config.messages.backend = :i18n

    params { required(:group_id).filled(:int?) }

    rule(:group_id) do
      key.failure(:already_exist) if Work.where.not(id: form.model.id).where(group_id: value, claim_id: form.claim_id).exists?
    end
  end

  # Обработка ответственных
  def populate_workers!(fragment:, **)
    item = workers.find { |worker| worker.user_id == fragment[:user_id].to_i }

    if fragment[:_destroy].to_s == 'true'
      workers.delete(item)
      return skip!
    end

    item || workers.append(Worker.new)
  end

  # Обработка списка комментариев
  # TODO: Запретить изменять существующие записи
  def populate_workflows!(fragment:, **)
    item = workflows.find { |workflow| workflow.id == fragment[:id].to_i }

    item || workflows.append(Workflow.new(sender: current_user))
  end
end
