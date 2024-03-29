# Класс заявки от пользователя
class SdRequest < Claim
  enum status: { opened: 1, at_work: 2, canceled: 3, done: 4 }, _suffix: true

  def self.default_service_name
    'Техподдержка'
  end

  def self.default_ticket_name
    'Обращение пользователя'
  end

  def ticket
    ServiceDesk::Ticket.new(
      identity: ticket_identity,
      name: ticket_name,
      service: { id: service_id, name: service_name }
    )
  end

  def ticket=(ticket)
    self.ticket_identity = ticket.identity
    self.ticket_name = ticket.name
    self.service_id = ticket.service.id
    self.service_name = ticket.service.name
  end
end
