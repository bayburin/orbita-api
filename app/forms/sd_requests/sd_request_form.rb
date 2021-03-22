module SdRequests
  # Описывает форму, которая создает заявку.
  class SdRequestForm < Reform::Form
    property :id
    property :service_id
    property :ticket_identity
    property :service_name, default: ->(**) { SdRequest.default_service_name }
    property :ticket_name, default: ->(**) { SdRequest.default_ticket_name }
    property :description
    property :status, default: ->(**) { Claim.default_status }
    property :priority, default: ->(**) { Claim.default_priority }
    property :attrs
    property :finished_at_plan, default: ->(**) { Claim.default_finished_at_plan }
    property :source_snapshot, form: SourceSnapshotForm, populator: :populate_source_snapshot!
    property :current_user, virtual: true
    collection :users, virtual: true
    collection :works, form: WorkForm
    collection :attachments, form: AttachmentForm, populate_if_empty: Attachment

    validates :description, :attrs, presence: true

    def validate(params)
      super(params)

      processing_users
    end

    # Обрабатывает источник заявки
    def populate_source_snapshot!(fragment:, **)
      self.source_snapshot = SourceSnapshotBuilder.build do |ss|
        ss.user_credentials = fragment[:id_tn] if fragment[:id_tn]
        ss.set_host_credentials(fragment[:invent_num]) if fragment[:invent_num]
      end
    end

    # Обработка списка работ
    # def populate_works!(fragment:, **)
    #   item = works.find { |work| work.id == fragment[:id].to_i }

    #   item || works.append(Work.new)
    # end

    protected

    # Обрабатывает список пользователей и создает работы по заявке, если необходимо.
    def processing_users
      user_instances = User.where(id: users.map { |u| u[:id] }).to_a
      # Проверяет наличие текущего пользователя в списке исполнителей.
      user_instances << current_user if users.none? { |u| u[:id] == current_user.id }
      # Добавляет "исполнителя по умолчанию", если в списке исполнителей отсутствуют работники УИВТ.
      employee = User.employee_user
      user_instances.push(*User.default_workers) if user_instances.none? { |user| user.role_id != employee.role_id }

      user_instances.group_by(&:group_id).each do |group_id, user_arr|
        work_form = works.find { |w| w.group_id == group_id }
        work = work_form.try(:model) || WorkBuilder.build(group_id: group_id)
        user_arr.each { |user| work.workers.build(user: user) unless work.workers.exists?(user_id: user.id) }

        works.append(work)
      end
    end
  end
end
