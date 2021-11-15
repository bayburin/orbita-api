module ServiceDesk
  module Lk
    class BuildSvtItemForm
      include Interactor

      delegate :params, :ticket, :doorkeeper_token, :current_user, to: :context

      def call
        context.sd_request = SdRequestBuilder.build(params) do |cl|
          cl.ticket = ticket
          cl.build_works_by_responsible_users(ticket.responsible_users)
          cl.application_id = doorkeeper_token.application.id
          cl.build_claim_application(doorkeeper_token.application.id, params[:integration_id])
          cl.status = :at_work
          # TODO: Здесь необходимо с помощью АСУ ФЭЗ расчитать sla.
          # cl.finished_at_plan = ticket.sla
        end
        context.form = SdRequests::CreateForm.new(context.sd_request)
      end
    end
  end
end
