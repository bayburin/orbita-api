module ServiceDesk
  module Lk
    class BuildSvtItemForm
      include Interactor

      delegate :current_user, to: :context

      def call
        ticket = Ticket.new(
          identity: 783,
          name: 'Заявка на выдачу/замену вычислительной техники',
          service: Service.new(id: 14, name: 'Выдача, замена и списание техники'),
          responsible_users: [{ tn: 24043 }, { tn: 24125 }]
        )
        context.sd_request = SdRequestBuilder.build do |cl|
          cl.ticket = ticket
          cl.build_works_by_responsible_users(ticket.responsible_users)
          cl.status = :at_work
          # TODO: Здесь необходимо с помощью АСУ ФЭЗ расчитать sla.
          # cl.finished_at_plan = ticket.sla
        end
        context.form = SdRequests::CreateForm.new(context.sd_request)
        context.params = {
          description: 'Выдача вычислительной техники в подразделение согласно перечня ПО',
          source_snapshot: { id_tn: current_user.id_tn }
        }
      end
    end
  end
end
