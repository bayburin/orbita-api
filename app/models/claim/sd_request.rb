# Класс заявки от пользователя
class SdRequest < Claim
  enum status: { opened: 1, at_work: 2, canceled: 3, approved: 4, reopened: 5 }, _suffix: true

  def service
    ServiceDesk::Service.new(id: service_id, name: service_name)
  end

  def service=(service)
    self.service_id = service.id
    self.service_name = service.name
  end

  def ticket
    ServiceDesk::Ticket.new(id: ticket_identity, name: ticket_name)
  end

  def ticket=(ticket)
    self.ticket_identity = ticket.id
    self.ticket_name = ticket.name
  end
end
