# Позволяет построить объект заявки SdRequest.
class SdRequestBuilder < BaseBuilder
  def initialize(params = {})
    @model = SdRequest.new(params)

    super()
  end

  def set_service(service_id, service_name)
    model.service = ServiceDesk::Service.new(id: service_id, name: service_name)
  end

  def set_ticket(ticket_identity, ticket_name)
    model.ticket = ServiceDesk::Ticket.new(id: ticket_identity, name: ticket_name)
  end

  def service_id=(service_id)
    model.service_id = service_id
  end

  def service_name=(service_name)
    model.service_name = service_name
  end

  def ticket_identity=(ticket_identity)
    model.ticket_identity = ticket_identity
  end

  def ticket_name=(ticket_name)
    model.ticket_name = ticket_name
  end

  def status=(status)
    model.status = status
  end

  def attrs=(attrs)
    model.attrs = attrs
  end

  def rating=(rating)
    model.rating = rating
  end

  def set_runtime(finished_at_plan, finished_at)
    model.runtime = Runtime.new(finished_at_plan: finished_at_plan, finished_at: finished_at)
  end

  def add_work(work)
    model.works << work
  end
end
