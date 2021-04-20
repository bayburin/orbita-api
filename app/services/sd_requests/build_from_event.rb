module SdRequests
  # Создает объект заявки.
  class BuildFromEvent
    include Interactor

    delegate :params, :ticket, :doorkeeper_token, to: :context

    def call
      context.sd_request = SdRequestBuilder.build(params) do |cl|
        cl.ticket = ticket
        cl.build_works_by_responsible_users(ticket.responsible_users)
        cl.application_id = doorkeeper_token.application.id
        cl.status = :at_work
        # TODO: Здесь необходимо с помощью АСУ ФЭЗ расчитать sla.
        # cl.finished_at_plan = ticket.sla
      end
      context.form = CreateForm.new(context.sd_request)

      params.merge!(source_snapshot: { id_tn: params[:id_tn] })
    end
  end
end
