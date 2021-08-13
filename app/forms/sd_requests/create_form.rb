module SdRequests
  # Описывает форму, которая создает заявку.
  class CreateForm < SdRequestForm
    property :service_id
    property :ticket_identity
    property :service_name
    property :ticket_name
    property :description
    property :status
    property :source_snapshot, form: SourceSnapshotForm, populator: :populate_source_snapshot!
    property :sla, virtual: true

    def description=(value)
      super value.strip
    end

    def service_name
      super || SdRequest.default_service_name
    end

    def ticket_name
      super || SdRequest.default_ticket_name
    end

    def status
      super || Claim.default_status
    end

    def finished_at_plan
      if sla
        JobInfo::CalculateClaimEndTime.new(current_user.tn, Time.zone.now, sla).calculate || Claim.default_finished_at_plan
      else
        Claim.default_finished_at_plan
      end
    end

    validation do
      config.messages.backend = :i18n

      params do
        required(:description).filled
        required(:source_snapshot).filled
      end
    end

    def sync
      result = super
      result.service_name = service_name
      result.ticket_name = ticket_name
      result.status = status
      result.finished_at_plan = finished_at_plan
      result
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
