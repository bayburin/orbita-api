module SdRequests
  # Описывает форму, которая создает заявку.
  class CreateForm < Reform::Form
    feature Coercion

    property :id
    property :service_id
    property :ticket_identity
    property :service_name, default: ->(**) { SdRequest.default_service_name }
    property :ticket_name, default: ->(**) { SdRequest.default_ticket_name }
    property :description
    property :status, default: ->(**) { Claim.default_status }
    property :priority, default: ->(**) { Claim.default_priority }
    property :attrs
    property :finished_at_plan, type: Types::Params::DateTime, default: ->(**) { Claim.default_finished_at_plan }
    property :source_snapshot, form: SourceSnapshotForm, populator: :populate_source_snapshot!
    property :current_user, virtual: true
    collection :works, form: WorkForm, populator: :populate_works!
    collection :attachments, form: AttachmentForm, populate_if_empty: Attachment

    validation do
      option :form
      config.messages.backend = :i18n

      params do
        required(:description).filled
        required(:source_snapshot).filled
        optional(:works)
      end

      rule(:works) do
        key.failure(:duplicate_groups) if value.map { |work| work[:group_id] }.uniq.count != value.count
      end
    end

    def validate(params)
      result = super(params)

      processing_users
      result
    end

    # Обрабатывает источник заявки
    def populate_source_snapshot!(fragment:, **)
      self.source_snapshot = SourceSnapshotBuilder.build do |ss|
        ss.user_credentials = fragment[:id_tn] if fragment[:id_tn]
        ss.set_host_credentials(fragment[:invent_num]) if fragment[:invent_num]
      end
    end

    # Обработка списка работ
    def populate_works!(fragment:, **)
      item = works.find { |work| work.id == fragment[:id].to_i }

      item || works.append(Work.new)
    end

    protected

    # Дополнительно обрабатывает список исполнителей. Добавляет в него текущего пользователя и, если необходимо,
    # добавляет "ответственных по умолчанию"
    def processing_users
      # Список id текущих исполнителей
      user_ids = works.map { |work| work.workers.map(&:user_id) }.flatten
      # Список объектов User, которых необходимо будет включить в список исполнителей по заявке
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
  end
end
