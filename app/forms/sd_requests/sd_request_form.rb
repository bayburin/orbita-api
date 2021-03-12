module SdRequests
  # Описывает форму, которая создает заявку.
  class SdRequestForm < Reform::Form
    property :id
    property :service_id
    property :app_template_id
    property :service_name, default: ->(**) { Claim.default_service_name }
    property :app_template_name
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
        ss.set_host_credentials(current_user, fragment[:invent_num]) if fragment[:invent_num]
      end
    end

    # Обработка списка работ
    # def populate_works!(fragment:, **)
    #   item = works.find { |work| work.id == fragment[:id].to_i }

    #   item || works.append(Work.new)
    # end

    protected

    # Обрабатывает список пользователей и создает работы по заявке, если необходимо.
    # Проверяет наличие текущего пользователя в списке исполнителей.
    def processing_users
      user_instances = User.where(id: users.map { |u| u[:id] }).to_a
      user_instances << current_user if users.none? { |u| u[:id] == current_user.id }

      # TODO: Тоже самое в классе FindOrCreateWork
      user_instances.each do |user|
        work = model.find_or_initialize_work_by_user(user)
        work.workers.build(user: user) unless work.workers.exists?(user_id: user.id)

        works.append(work)
      end
    end
  end
end
