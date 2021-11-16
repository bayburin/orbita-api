module Scope
  # Сортировка по id
  def by_id(direction)
    order(id: direction)
  end

  # Поиск по ticket_identity
  def by_ticket_identity(ticket_identity)
    where(ticket_identity: ticket_identity)
  end

  # Поиск по присоединенной таблице claim_applications
  def by_app_integration(application_id, integration_id)
    joins(:claim_applications).where(
      claim_applications: { integration_id: integration_id, application_id: application_id }
    )
  end
end
