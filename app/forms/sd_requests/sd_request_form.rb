module SdRequests
  # Описывает базовую форму заявки.
  class SdRequestForm < Reform::Form
    feature Coercion

    property :id
    property :integration_id
    property :application_id
    property :priority
    property :finished_at_plan
    collection :parameters, form: ParameterForm, populate_if_empty: Parameter
    collection :works, form: WorkForm, populator: :populate_works!
    collection :attachments, form: AttachmentForm, populator: :populate_attachments!
    collection :comments, form: MessageForm, populator: :populate_comments!

    attr_accessor :current_user, :history_store

    validation do
      option :form
      config.messages.backend = :i18n

      params { optional(:works) }

      rule(:works) do
        key.failure(:duplicate_groups) if value.map { |work| work[:group_id] }.uniq.count != value.count
      end
    end

    def priority
      super || Claim.default_priority
    end

    def finished_at_plan
      super || Claim.default_finished_at_plan
    end

    def validate(params)
      result = super(params)
      processing_users
      processing_history
      result
    end

    def sync
      result = super
      result.priority = priority
      result.finished_at_plan = finished_at_plan
      result
    end

    # Обработка списка работ
    def populate_works!(fragment:, **)
      item = works.find { |work| work.id == fragment[:id].to_i }

      (item || works.append(Work.new)).tap do |w|
        w.current_user = current_user
        w.history_store = history_store
        w.employee_user = User.employee_user
      end
    end

    def populate_attachments!(fragment:, **)
      item = attachments.find { |attachment| attachment.id == fragment[:id].to_i }

      if fragment[:_destroy].to_s == 'true'
        p 'HERE'
        attachments.delete(item)

        return skip!
      end

      item || attachments.append(Attachment.new)
    end

    # Обработка списка комментариев
    def populate_comments!(fragment:, **)
      return skip! if fragment[:id]

      comments.append(Comment.new(sender: current_user))
    end

    protected

    # Дополнительно обрабатывает список исполнителей. Добавляет в него текущего пользователя и, если необходимо,
    # добавляет "ответственных по умолчанию"
    def processing_users
      # Список id текущих исполнителей
      user_ids = works.map { |work| work.workers.map(&:user_id) }.flatten
      # Список пользователей, которых необходимо будет включить в список исполнителей по заявке
      user_instances = []

      # Проверяет наличие текущего пользователя в списке исполнителей.
      unless user_ids.include?(current_user.id)
        user_instances << current_user
        user_ids << current_user.id
      end

      # Добавляет "исполнителей по умолчанию", если в списке исполнителей отсутствуют работники УИВТ.
      employee = User.employee_user
      user_instances.push(*User.default_workers) if User.where(id: user_ids).none? { |user| user.role_id != employee.role_id }

      # Конечная обработка массива user_instances.
      user_instances.group_by(&:group_id).each do |group_id, user_arr|
        work_form = works.find { |w| w.group_id == group_id }

        if work_form
          user_arr.each { |user| work_form.workers.append(Worker.new(user_id: user.id)) }
        else
          work = WorkBuilder.build(group_id: group_id)
          user_arr.each { |user| work.workers.build(user: user) }
          works.append(work)
        end
      end
    end

    def processing_history; end
  end
end
