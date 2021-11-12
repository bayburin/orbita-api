module ServiceDesk
  module Lk
    class BuildSvtItemForm
      include Interactor

      delegate :params, :ticket, :doorkeeper_token, :current_user, to: :context

      def call
        application_id =
          case params[:ticket_identity]
          when 783 then Doorkeeper::Application.find_by(name: 'СВТ').try(:id)
          end

        context.sd_request = SdRequestBuilder.build(params) do |cl|
          cl.ticket = ticket
          cl.build_works_by_responsible_users(ticket.responsible_users)
          cl.application_id = application_id || doorkeeper_token.application.id
          cl.status = :at_work
          # TODO: Здесь необходимо с помощью АСУ ФЭЗ расчитать sla.
          # cl.finished_at_plan = ticket.sla
        end
        context.form = SdRequests::CreateForm.new(context.sd_request)
      end
    end
  end
end
