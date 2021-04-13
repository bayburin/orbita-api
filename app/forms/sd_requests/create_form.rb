module SdRequests
  # Описывает форму, которая создает заявку.
  class CreateForm < SdRequestForm
    property :service_id
    property :ticket_identity
    property :service_name, default: ->(**) { SdRequest.default_service_name }
    property :ticket_name, default: ->(**) { SdRequest.default_ticket_name }
    property :description
    property :status, default: ->(**) { Claim.default_status }
    property :source_snapshot, form: SourceSnapshotForm, populator: :populate_source_snapshot!

    validation do
      config.messages.backend = :i18n

      params do
        required(:description).filled
        required(:source_snapshot).filled
      end
    end

    # Обрабатывает источник заявки
    # TODO: Случай, если данные в форме пришли, но НСИ недоступен.
    def populate_source_snapshot!(fragment:, **)
      self.source_snapshot = SourceSnapshotBuilder.build do |ss|
        ss.user_credentials = fragment[:id_tn] if fragment[:id_tn]
        ss.host_credentials = fragment[:invent_num] if fragment[:invent_num]
      end
    end

    protected

    def processing_history
      history_store.add(Histories::OpenType.new.build)
      super
    end
  end
end
