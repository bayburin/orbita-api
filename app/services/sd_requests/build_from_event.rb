module SdRequests
  # Создает объект заявки.
  class BuildFromEvent
    include Interactor

    delegate :params, :ticket, to: :context

    def call
      context.sd_request = SdRequestBuilder.build(params) do |cl|
        cl.ticket = ticket
        # TODO: Здесь необходимо с помощью АСУ ФЭЗ расчитать sla.
        # cl.finished_at_plan = ticket.sla
      end
      context.form = SdRequestForm.new(context.sd_request)

      params.merge!(source_snapshot: { id_tn: params[:id_tn] })
    end
  end
end
